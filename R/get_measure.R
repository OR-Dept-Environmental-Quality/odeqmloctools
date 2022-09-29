#' Get measure value along Oregon NHDH_OR_931v220.
#'
#' The function will query Oregon DEQ's NHD REST service to determine the measure
#' value along a target NHD flowline. The Permanent Identifier (pid) is used to
#' select a specific reach from the REST service. The x and y coordinates are snapped
#' to the nearest vertex on the selected flowline and the measure value determined.
#' If return_sf=TRUE the sf object is projected into ESPG:4326 (WGS84) which is
#' the expected default for \code{\link[leaflet]{leaflet}}.
#'
#' This function is intended to be a helper function for
#' \code{\link{launch_map}} although it may be used independently as well.
#' Compatible with piping.
#'
#' The feature service can be accessed at \url{https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/NHDH_ORDEQ/MapServer/1}.
#'
#' @param pid The NHD Permanent_Identifier value as a string. Required.
#' @param x The longitude in decimal degrees. Required.
#' @param y The latitude in decimal degrees. Required.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @param return_sf Boolean. A TRUE value will return the sf object with data
#'      frame columns for GNIS_Name, Permanent_Identifier, ReachCode, Measure,
#'      Snap.Lat, and Snap.Long.
#'      FALSE will return the measure value as a character. Default is FALSE.
#' @export
#' @return sf object with data frame columns for Permanent_Identifier, ReachCode,
#'         Measure, Snap.Lat, and Snap.Long.
get_measure <- function(pid, x, y, crs, return_sf=FALSE){

  df <- purrr::pmap_dfr(list(pid, x, y, crs), return_sf = TRUE,
                        .f = get_measure_)

}

#' Work horse function. Non vectorized. Retrieves geometry from REST service
#' using PID. This is primarily for use with \code{\link{launch_map}}.
#'
#' @noRd
get_measure_ <- function(pid, x, y, crs=4326, return_sf=FALSE){

  # Test data
  #pid="165555667"
  #reachcode="18010206003567"
  #crs=4326
  #y=42.09361
  #x=-122.3822

  # web mercator
  #to_crs <- 3857

  query_url  <- "https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/NHDH_ORDEQ/MapServer/1/query?where="

  request <- httr::GET(url = URLencode(paste0(query_url , "Permanent_Identifier='",pid,
                                              "'&outFields=*&returnGeometry=true&returnIdsOnly=false&f=GeoJSON")))

  response <- httr::content(request, as = "text", encoding = "UTF-8")

  line_df <- geojsonsf::geojson_sf(response)

  if (httr::http_error(request) | NROW(line_df) == 0) {
    warning("Error, NA returned")

    if (return_sf) {
      return(dplyr::mutate(site,
                           GNIS_Name = NA_character_,
                           Permanent_Identifier = NA_character_,
                           ReachCode = NA_character_,
                           Measure = NA_real_,
                           Snap.Lat = NA_real_,
                           Snap.Long - NA_real_) %>%
               dplyr::select(GNIS_Name, Permanent_Identifier, ReachCode, Measure, Snap.Lat, Snap.Long, geometry) %>%
               sf::st_transform(crs = 4326))
    } else {
      return(NA_character_)
    }
  }

  # feature service out crs, WGS84
  fs_crs <- 4326

  # Make a point from x and y  and make sure it's in the same projection as the line
  point <- sf::st_as_sf(data.frame(Longitude = x, Latitude = y),
                        coords = c("Longitude", "Latitude"), crs = crs) %>%
    sf::st_transform(point, crs = sf::st_crs(line_df))

  reach_df <- line_df %>%
    sf::st_drop_geometry()

  # get measure value at top and bottom
  reach <- line_df %>%
    sf::st_cast( to = "POINT") %>%
    dplyr::mutate(Measure = unlist(lapply(geometry, FUN = function(x) {x[4]}), recursive = TRUE))

  meas_max <- max(reach$Measure)
  meas_min <- min(reach$Measure)

  rm(reach)

  # Split line into segments
  reach1 <- line_df %>%
    sf::st_transform(crs = fs_crs) %>%
    sf::st_cast(to = "LINESTRING") %>%
    sf::st_zm() %>%
    split_lines(max_length = 25, id = "ReachCode")

  # segment length in meters
  reach1$length_seg <- units::set_units(sf::st_length(reach1), m)

  reach_points <- sf::st_cast(reach1, to = "POINT")
  reach_points$row = as.numeric(row.names(reach_points))

  # Get only the first point on each linestring segment, and the last point (most upstream). Use the row number to filter.
  reach_points <- dplyr::filter(reach_points, row %in% c(1:nrow(reach_points),  max(reach_points$row)))

  # Set first point to length zero
  reach_points[1,c("length_seg")] <- 0

  # Snap distance in meters because of crs
  reach_points$Snap.Distance <- sf::st_distance(reach_points, point, by_element = TRUE)

  if (units::set_units(min(reach_points$Snap.Distance), m) > units::set_units(400, m))
    warning("Snap distance is > 400 meters. Is the x and y near the target Reach?")

  # Calculate measure, filter to the closest point and clean up
  df_meas <- reach_points %>%
    dplyr::mutate(Total_Meters = as.numeric(cumsum(length_seg)),
                  Measure = round(meas_min + ((max(Total_Meters) - Total_Meters) * (meas_max - meas_min) / max(Total_Meters)), 2)
                  ) %>%
    dplyr::slice_min(Snap.Distance, with_ties = FALSE) %>%
    dplyr::left_join(reach_df) %>%
    dplyr::mutate(Snap.Lat = unlist(lapply(geometry, FUN = function(x) {x[2]}), recursive = TRUE),
                  Snap.Long = unlist(lapply(geometry, FUN = function(x) {x[1]}), recursive = TRUE)) %>%
    sf::st_zm() %>%
    dplyr::select(GNIS_Name, Permanent_Identifier, ReachCode, Measure, Snap.Lat, Snap.Long)

  if (return_sf) {
    return(df_meas)
  } else {
    return(df_meas$Measure)
  }
}

#' Get measure value along a line
#'
#' Calculate the measure value given an input point and NHD line. The measure value is
#' determined after snapping the point to the line.
#'
#' @param line The input NHD feature as an sf object with a geometry column.
#' @param point The input point feature as an sf object with a geometry column
#' @param id Column name in 'line' used to identify the polyline and calculate
#'      measure distance along. Typically 'ReachCode' or 'REACHCODE'.
#' @param return_df Boolean. A TRUE value will return the data
#'      frame with columns for Measure, Snap.Lat, Snap.Long, and Snap.Distance.
#'      FALSE will return the measure value
#'      as a character. Default is FALSE.
#'@param nhdplus Boolean. Default is FALSE. A TRUE value will use the NHDplus fields
#'      'TOMEAS' and 'FROMMEAS' in the measure calculation instead of the m value
#'      from the feature geometry. NHDplus geometry returned
#'      from USGS's REST service does not include a m value by default.
#'
#' @export
get_measure2 <- function(line, point, id, return_df = FALSE, nhdplus = FALSE){

  # feature service out crs, WGS84
  #fs_crs <- 4326

  # Make sure the point and line are in the same projection
  point <- sf::st_transform(point, crs = sf::st_crs(line))

  reach_df <- line %>%
    sf::st_drop_geometry()

  # get measure value at top and bottom
  reach <- line %>%
    sf::st_cast( to = "POINT") %>%
    dplyr::mutate(Measure = unlist(lapply(geometry, FUN = function(x) {x[4]}), recursive = TRUE))

  if (nhdplus) {

    meas_max <- max(reach$TOMEAS)
    meas_min <- min(reach$FROMMEAS)

  } else {
    meas_max <- max(reach$Measure)
    meas_min <- min(reach$Measure)
  }

  rm(reach)

  # Split line into segments
  reach1 <- line %>%
    #sf::st_transform(crs = fs_crs) %>%
    sf::st_cast(to = "LINESTRING") %>%
    sf::st_zm() %>%
    split_lines(max_length = 25, id = id)

  # segment length in meters
  reach1$length_seg <- units::set_units(sf::st_length(reach1), m)

  reach_points <- sf::st_cast(reach1, to = "POINT")
  reach_points$row = as.numeric(row.names(reach_points))

  # Get only the first point on each linestring segment, and the last point (most upstream). Use the row number to filter.
  reach_points <- dplyr::filter(reach_points, row %in% c(1:nrow(reach_points),  max(reach_points$row)))

  # Set first point to length zero
  reach_points[1,c("length_seg")] <- 0

  # Snap distance in meters because of crs
  reach_points$Snap.Distance <- sf::st_distance(reach_points, point, by_element = TRUE)

  if (units::set_units(min(reach_points$Snap.Distance), m) > units::set_units(400, m))
    warning("Snap distance is > 400 meters. Is the point near the line?")

  # Calculate measure, filter to the closest point and clean up
  df_meas <- reach_points %>%
    dplyr::mutate(Total_Meters = as.numeric(cumsum(length_seg)),
                  Measure = round(meas_min + ((max(Total_Meters) - Total_Meters) * (meas_max - meas_min) / max(Total_Meters)), 2)
                  ) %>%
    dplyr::slice_min(Snap.Distance, with_ties = FALSE) %>%
    dplyr::mutate(Snap.Lat = unlist(lapply(geometry, FUN = function(x) {x[2]}), recursive = TRUE),
                  Snap.Long = unlist(lapply(geometry, FUN = function(x) {x[1]}), recursive = TRUE)) %>%
    sf::st_drop_geometry() %>%
    dplyr::select(Measure, Snap.Lat, Snap.Long, Snap.Distance)

  if (return_df) {
    return(df_meas)
  } else {
    return(df_meas$Measure)
  }
}
