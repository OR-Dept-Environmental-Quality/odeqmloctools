#' Get HUC8 info
#'
#' The function will query Oregon DEQ's WBD feature service to determine the HUC8
#' subbasin code and name. The x and y coordinates (longitude and latitude) are
#' used to select a specific HUC8 from the feature service. The WBD version is
#' included with NHDH_OR_931v220.
#'
#' The feature service can be accessed at \url{https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/1}.
#' The feature service column Name is changed to HUC8_Name.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @seealso \code{\link{get_huc8code}}, \code{\link{get_huc8name}}
#' @export
#' @return data frame columns for HUC8 and HUC8_Name
get_huc8 <- function(x, y, crs){
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_huc8_)
  return(df)

}

#' Get HUC8 code
#'
#' The function will query Oregon DEQ's WBD feature service to determine the
#' HUC8 subbasin code. The x and y coordinates (longitude and latitude) are
#' used to select a specific HUC8 from the feature service.
#'
#' The feature service can be accessed at \url{https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/1}.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @seealso \code{\link{get_huc8}}, \code{\link{get_huc8name}}
#' @export
#' @return The HUC8 code as character format
get_huc8code <- function(x, y, crs) {
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_huc8_)
  return(df$HUC8)
}


#' Get HUC8 name
#'
#' The function will query Oregon DEQ's WBD feature service to determine
#' the HUC8 subbasin name. The x and y coordinates (longitude and latitude) are
#' used to select a specific HUC8 from the feature service.
#'
#' The feature service can be accessed at \url{https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/1}.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @seealso \code{\link{get_huc8}}, \code{\link{get_huc8code}}
#' @export
#' @return The HUC8 name
get_huc8name <- function(x, y, crs) {
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_huc8_)
  return(df$HUC8_Name)
}


#' Non vectorized version of get_huc8. This is what purrr calls.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value.
#' @noRd
#' @return data frame columns for HUC8 and HUC8_Name
get_huc8_ <- function(x, y, crs){

  # Test data
  # y=42.09361
  # x=-122.3822

  # Idaho (error)
  # y = 44.24176
  # x = -116.9416

  if (x < -124.6155 | x > -116.3519) {
    warning("y is far outside of Oregon")
  }

  if (y < 41.8075 | y > 46.3586) {
    warning("x is far outside of Oregon")
  }

  query_url <- "https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/1/query?"

  request <- httr::GET(url = URLencode(paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                              "&inSR=",crs,"&outFields=*&returnGeometry=false",
                                              "&returnIdsOnly=false&f=GeoJSON"), reserved = FALSE))

  response <- httr::content(request, as = "text", encoding = "UTF-8")

  df <- geojsonsf::geojson_sf(response)

  if (httr::http_error(request) | NROW(df) == 0) {
    warning("Error, NA returned")
    return(data.frame(HUC8 = c(NA_character_), HUC8_Name = c(NA_character_),
                      stringsAsFactors = FALSE))
  }

  df <- dplyr::select(df, HUC8, HUC8_Name = Name)

  return(df)

}
