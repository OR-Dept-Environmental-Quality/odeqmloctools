#' Get the river mile along the LLID
#'
#' The function will query Oregon DEQ's LLID streams feature service to determine
#' the river mile value along the target LLID polyline given a nearby latitude and
#' longitude. The LLID value is used to select a specific reach from the feature
#' service. The LLID is split into 0.01 mile (53 foot) segments with a vertex on either end
#' of the segment. The x and y coordinates are snapped to the nearest vertex.
#' The river mile is calculated based on the distance from the downstream end of the
#' LLID. The feature data is projected into ESPG:2994 (Oregon Lambert NAD83 HARN)
#' for all operations. Units are feet. If return_sf=TRUE the sf is projected
#' into ESPG:4326 (WGS84) which is the expected default for
#' \code{\link[leaflet]{leaflet}}.
#'
#' This function is intended to be a helper function for \code{\link{launch_map}}
#' although it may be used independently as well.
#'
#' The LLID feature service can be accessed at \url{https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/DEQ_Streams/MapServer/0/}.
#'
#' @param llid The LLID value as a string.
#' @param x The longitude in decimal degrees
#' @param y The latitude in decimal degrees
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @param return_sf logical. Default is FALSE. A TRUE value will return a sf
#'        point object of the snapped location with data frame columns for
#'        Stream 'NAME', 'LLID', 'River_Mile' of the snapped locations, and 'RM_Total' for the total
#'        LLID river miles.
#' @export
#' @return river mile info

get_llidrm <- function(llid, x, y, crs, return_sf=FALSE){

  df <- purrr::pmap_dfr(list(llid, x, y, crs), return_sf = TRUE,
                        .f = get_llidrm_)
  }

#' Work horse function. Non vectorized. Retrieves geometry from REST service
#' using LLID. This is primarily for use with \code{\link{launch_map}}.
#'
#' @noRd
get_llidrm_ <- function(llid, x, y, crs=4326, return_sf=FALSE){

  # Test data
  # y = 42.09361
  # x = -122.3822
  # crs = 4326
  # llid <- "1223681420918"
  # return_sf = FALSE

  # Oregon GIC Lambert (ft) NAD83(HARN)
  to_crs <- 2994

  query_url <- "https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/DEQ_Streams/MapServer/0/query?where="

  # get the LLID reach
  request <- httr::GET(url = paste0(query_url, "LLID='",llid,"'&outFields=*&returnGeometry=true&returnIdsOnly=false&f=GeoJSON"))

  response <- httr::content(request, as = "text", encoding = "UTF-8")

  line_df <- geojsonsf::geojson_sf(response) %>%
    sf::st_transform(crs = to_crs)

  # Make a point from x and y and make sure it's in the same projection as the line

  # get the site, make sf object, NAD 83 EPSG:4269
  point <- sf::st_as_sf(data.frame(Longitude = x, Latitude = y),
                        coords = c("Longitude", "Latitude"), crs = 4269) %>%
    sf::st_transform(crs = to_crs)


  if (httr::http_error(request) | NROW(line_df) == 0) {
    warning("Error, NA returned")

    if (return_sf) {
      return(dplyr::mutate(point,
                           NAME = NA_character_,
                           RM_Total = NA_real_,
                           LLID = NA_character_,
                           River_Mile = NA_real_) %>%
               dplyr::select(NAME, RM_Total, LLID, River_Mile, geometry))

      return(NA_real_)
    }
  }

  fs_stream_name <- unique(line_df$NAME)[1]
  rm_min <- min(line_df$RM_MIN)

  # get measure value at top and bottom, measured in feet (convert to miles)
  meas_vector <- as.data.frame(sf::st_coordinates(line_df))$M
  meas_top <- meas_vector[1] * 0.000189394
  meas_bot <- meas_vector[length(meas_vector)] * 0.000189394

  top_upstream <- (meas_top > meas_bot)

  reach1 <- line_df %>%
    sf::st_zm() %>%
    sf::st_segmentize(dfMaxLength = units::set_units(0.01, mi)) %>%
    sf::st_cast(to = "POINT") %>%
    dplyr::mutate(LLID = llid,
                  NAME = fs_stream_name) %>%
    dplyr::group_by(LLID) %>%
    dplyr::mutate(row = dplyr::row_number()) %>%
    dplyr::ungroup()

  # segment length in miles
  if (top_upstream) {
    # upstream end at top
    reach1$length_seg <- c(sf::st_distance(x = reach1[-1,], y = reach1[-nrow(reach1),], by_element = TRUE), units::set_units(0, mi))

  } else {
    # upstream end at bottom
    reach1$length_seg <- c(units::set_units(0, mi), sf::st_distance(x = reach1[-nrow(reach1),], y = reach1[-1,], by_element = TRUE))
  }

  reach1$Snap.Distance <- sf::st_distance(reach1, point, by_element = FALSE)[,1]

  if (units::set_units(min(reach1$Snap.Distance), mi) > units::set_units(0.25, mi)) {
    warning("Snap distance is > 0.25 miles. Is the x and y near the target LLID?")
    }

  # Calculate measure, filter to the closest point and clean up
  df_meas <- reach1 %>%
    dplyr::arrange(if (top_upstream) {-row} else {row}) %>%
    dplyr::mutate(Total_Mile = as.numeric(cumsum(length_seg)),
                  River_Mile = round(rm_min + Total_Mile, 2)) %>%
    dplyr::slice_min(Snap.Distance, with_ties = FALSE) %>%
    sf::st_transform(crs = 4326) %>% # for leaflet and getting snap lat/long
    dplyr::mutate(Snap.Lat = unlist(lapply(geometry, FUN = function(x) {x[2]}), recursive = TRUE),
                  Snap.Long = unlist(lapply(geometry, FUN = function(x) {x[1]}), recursive = TRUE)) %>%
    sf::st_zm() %>%
    dplyr::select(NAME, RM_Total, LLID, River_Mile)

  #ggplot2::ggplot() + ggplot2::geom_sf(data = df_meas) + ggplot2::geom_sf(data = point) + ggplot2::geom_sf(data = sf::st_zm(line_df))

  if (return_sf) {
    return(df_meas)
  } else {
    return(df_meas$River_Mile)
  }
}
