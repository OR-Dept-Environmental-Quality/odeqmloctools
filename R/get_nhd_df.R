#' Get NHD High info as a dataframe
#'
#' The function will query the NHD High REST service from Oregon DEQ or USGS and return a
#' dataframe containing the NHD flowline info. The supplied x and y coordinates
#' (longitude and latitude) are used to select the closest NHD flowline record. Only the closest
#' flowline within the search distance is returned. If there are no flowlines
#' within the search distance the returned dataframe will contain all NAs. If two or more flowline
#' records are equal distance to x and y only the first record will be returned.
#'
#' Two REST feature services can be accessed. DEQ and USGS. Use the 'service'
#' argument to specific which service to use. DEQ's REST service is based
#' on NHDH_OR_931v220 at https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/NHDH_ORDEQ/MapServer/1.
#' USGS's national map REST service is the most recent version of NHD high and
#' located at https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer/4.
#'
#' @param .data A data frame
#' @param x The longitude in decimal degrees. Required. Accepts a vector.
#' @param y The latitude in decimal degrees. Required. Accepts a vector.
#' @param crs The coordinate reference system for x and y. Same format as [sf::st_crs].
#'     Typically entered using the numeric EPSG value. Accepts a vector.
#' @param search_dist The maximum search distance around x and y to look for features.
#'        Measured in meters. Default is 100.
#' @param service The feature service to query. Options include "DEQ" or "USGS". Default is "DEQ".
#'   If USGS, the query will be send to the NHD flowline feature service on the National Map.
#' @export
#' @return sf object with data frame columns for Permanent_Identifier, ReachCode, measure, and Snap_Distance

get_nhd_df <- function(.data, x, y, crs, search_dist = 100, service = "DEQ"){

  if (length(.data[[deparse(substitute(x))]]) != length(.data[[deparse(substitute(y))]])) {
    stop("x and y must have the same number of elements")
  }

  if (service == "DEQ") {

    df <- purrr::pmap_dfr(list(.data[[deparse(substitute(x))]],
                               .data[[deparse(substitute(y))]],
                               .data[[deparse(substitute(crs))]]),
                          search_dist = search_dist,
                          .f = get_nhd_)
  } else if (service == "USGS") {

    df <- purrr::pmap_dfr(list(.data[[deparse(substitute(x))]],
                               .data[[deparse(substitute(y))]],
                               .data[[deparse(substitute(crs))]]),
                          search_dist = search_dist,
                          .f = get_nhd_usgs)
  } else { stop("service must be either 'DEQ' or 'USGS'")}

  # reset row numbers
  row.names(df) <- NULL

  return(df)

}

#' Non vectorized version of get_nhd . This is what purrr calls.
#'
#' @noRd
get_nhd_ <- function(x, y, crs, search_dist = 100) {

  # Test data
  # y=42.09359
  # x=-122.3813
  # pid="165555667"
  # crs = 4326
  # search_dist = 100

  # Idaho (error)
  # y = 44.24176
  # x = -116.9416

  # feature service out crs, WGS84
  fs_crs <- 4326

  query_url  <- "https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/NHDH_ORDEQ/MapServer/1/query?"


  request <- httr::GET(url = URLencode(paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                              "&inSR=",crs,"&outFields=*&returnGeometry=true",
                                              "&distance=",search_dist,"&units=esriSRUnit_Meter&returnIdsOnly=false&f=GeoJSON"), reserved = FALSE))


  response <- httr::content(request, as = "text", encoding = "UTF-8")

  reach_df <- geojsonsf::geojson_sf(response)

  # get the site, make sf object
  site <- sf::st_as_sf(data.frame(Longitude = x, Latitude = y),
                       coords = c("Longitude", "Latitude"), crs = crs)

  if (httr::http_error(request) | NROW(reach_df) == 0) {
    warning("Error, NA returned")

    return(dplyr::mutate(site,
                         GNIS_ID = NA_character_,
                         GNIS_Name = NA_character_,
                         Permanent_Identifier = NA_character_,
                         ReachCode = NA_character_,
                         WBArea_Permanent_Identifier = NA_character_,
                         FType = NA_real_,
                         FCode = NA_real_,
                         MainPath = NA_real_,
                         InNetwork = NA_real_,
                         Measure = NA_real_,
                         Snap_Lat = NA_real_,
                         Snap_Long = NA_real_,
                         Snap_Distance = units::set_units(NA_real_, m)) %>%
             dplyr::select(GNIS_ID, GNIS_Name, Permanent_Identifier, ReachCode,
                           WBArea_Permanent_Identifier, FType, FCode, MainPath,
                           InNetwork, Measure, Snap_Lat, Snap_Long, Snap_Distance,
                           geometry) %>%
             sf::st_transform(site, crs = fs_crs))
  }

  # get the site, make sf object
  site <- sf::st_transform(site, crs = sf::st_crs(reach_df))

  reach_df$Snap_Distance <- sf::st_distance(site, reach_df, by_element = TRUE)

  # return row that is closest
  reach_df2 <- reach_df %>%
    dplyr::slice_min(Snap_Distance, with_ties = FALSE) %>%
    dplyr::select(GNIS_ID, GNIS_Name, Permanent_Identifier, ReachCode,
                  WBArea_Permanent_Identifier, FType, FCode, MainPath, InNetwork,
                  geometry)

  df_meas <- get_measure2(line = reach_df2, point = site, return_df = TRUE)
  reach_df3 <- cbind(reach_df2, df_meas)

  return(reach_df3)

}


#' Non vectorized version of get_nhd . This is what purrr calls.
#'
#' @noRd
get_nhd_usgs <- function(x, y, crs, search_dist = 100) {

  # Test data
  # y=42.09359
  # x=-122.3813
  # pid="165555667"
  # search_dist = 100

  # Idaho (error)
  # y = 44.24176
  # x = -116.9416

  # feature service out crs, WGS84
  fs_crs <- 4326

  query_url  <- "https://hydro.nationalmap.gov/arcgis/rest/services/nhd/MapServer/6/query?"


  request <- httr::GET(url = URLencode(paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                              "&inSR=",crs,"&outFields=*&returnGeometry=true",
                                              "&distance=",search_dist,"&units=esriSRUnit_Meter&returnIdsOnly=false&f=GeoJSON"), reserved = FALSE))


  response <- httr::content(request, as = "text", encoding = "UTF-8")

  reach_df <- geojsonsf::geojson_sf(response)

  # get the site, make sf object
  site <- sf::st_as_sf(data.frame(Longitude = x, Latitude = y),
                       coords = c("Longitude", "Latitude"), crs = crs)

  if (httr::http_error(request) | NROW(reach_df) == 0) {
    warning("Error, NA returned")

    return(dplyr::mutate(site,
                         GNIS_ID = NA_character_,
                         GNIS_Name = NA_character_,
                         Permanent_Identifier = NA_character_,
                         ReachCode = NA_character_,
                         WBArea_Permanent_Identifier = NA_character_,
                         FType = NA_real_,
                         FCode = NA_real_,
                         MainPath = NA_real_,
                         InNetwork = NA_real_,
                         Measure = NA_real_,
                         Snap_Lat = NA_real_,
                         Snap_Long = NA_real_,
                         Snap_Distance = units::set_units(NA_real_, m)) %>%
             dplyr::select(GNIS_ID, GNIS_Name, Permanent_Identifier, ReachCode,
                           WBArea_Permanent_Identifier, FType, FCode, Measure,
                           Snap_Lat, Snap_Long, Snap_Distance, geometry) %>%
             sf::st_transform(site, crs = fs_crs))
  }

  # get the site, make sf object
  site <- sf::st_transform(site, crs = sf::st_crs(reach_df))

  reach_df$Snap_Distance <- sf::st_distance(site, reach_df, by_element = TRUE)

  # return row that is closest
  reach_df2 <- reach_df %>%
    dplyr::slice_min(Snap_Distance, with_ties = FALSE) %>%
    dplyr::select(GNIS_ID,
                  GNIS_Name = GNIS_NAME,
                  Permanent_Identifier = PERMANENT_IDENTIFIER,
                  ReachCode = REACHCODE,
                  WBArea_Permanent_Identifier = WBAREA_PERMANENT_IDENTIFIER,
                  FType = FTYPE,
                  FCode = FCODE,
                  InNetwork = INNETWORK,
                  MainPath = MAINPATH,
                  geometry)

  df_meas <- get_measure2(line = reach_df2, point = site, id = "ReachCode", return_df = TRUE)
  reach_df3 <- cbind(reach_df2, df_meas)

  return(reach_df3)

}


