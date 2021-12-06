#' Get NHD Permanent_Identifier
#'
#' The function will query Oregon DEQ's NHD feature service to determine the
#' Permanent_Identifier value along a target NHD flowline. The x and y coordinates
#' (longitude and latitude) are used to select the flowline.  The permanent_Identifier
#' returned is based on the flowline that is closest to the coordinates.
#'
#' The feature service can be accessed at https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/NHDH_ORDEQ/MapServer/1
#' The feature service is based on NHDH_OR_931v220.
#'
#' @param x The longitude in decimal degrees. Required. Accepts a vector.
#' @param y The latitude in decimal degrees. Required. Accepts a vector.
#' @param crs The coordinate reference system for x and y. Same format as [sf::st_crs]. Typically entered using the numeric EPSG value. Accepts a vector.
#'  Typically entered using the numeric EPSG value. Accepts a vector.
#' @param search_dist The maximum search distance around x and y to look for features. Measured in meters. Default is 100.
#' @export
#' @return Permanent_Identifier

get_nhd_pid <- function(x, y, crs, search_dist = 100) {

  if (length(x) != length(y)) {
    stop("x and y must have the same number of elements")
  }

  arglist <- list(x, y, crs)

  df <- purrr::pmap_dfr(arglist, search_dist = search_dist, measure = FALSE,
                        .f = get_nhd_)

  return(df$Permanent_Identifier)
}
