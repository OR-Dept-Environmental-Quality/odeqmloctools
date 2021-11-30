#' Get HUC12 info
#'
#' The function will query Oregon DEQ's WBD feature service to determine the HUC12 subwatershed code and name. The x and y coordinates (longitude and latitude) are
#' used to select a specific HUC12 from the feature service. The WBD version is included with NHDH_OR_931v220.
#'
#' The feature service can be accessed at https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/3.
#' The feature service column Name is changed to HUC12_Name.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @seealso [get_huc12code()] and [get_huc12name()]
#' @export
#' @return data frame columns for HUC12 and HUC12_Name
get_huc12 <- function(x, y) {
  df <- purrr::map2_dfr(.x = x, .y = y, .f = get_huc12_)
  return(df)
}


#' Get HUC12 code
#'
#' The function will query Oregon DEQ's WBD feature service to determine the
#' HUC12 subwatershed code. The x and y coordinates (longitude and latitude) are
#' used to select a specific HUC12 from the feature service.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @seealso [get_huc12()], [get_huc12name()]
#' @export
#' @return The HUC12 code as character format
get_huc12code <- function(x, y) {
  df <- purrr::map2_dfr(.x = x, .y = y, .f = get_huc12_)
  return(df$HUC12)
}


#' Get HUC12 name
#'
#' The function will query Oregon DEQ's WBD feature service to determine
#' the HUC12 subwatershed name. The x and y coordinates (longitude and latitude) are
#' used to select a specific HUC12 from the feature service.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @seealso [get_huc12()], [get_huc12code()]
#' @export
#' @return The HUC12 name
get_huc12name <- function(x, y) {
  df <- purrr::map2_dfr(.x = x, .y = y, .f = get_huc12_)
  return(df$HUC12_Name)
}


#' Non vectorized version of get_huc12. This is what purrr calls.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @noRd
#' @return data frame columns for HUC12 and HUC12_Name
get_huc12_ <- function(x, y){

  # Test data
  # y=42.09361
  # x=-122.3822

  if (x < -124.6155 | x > -116.3519) {
    warning("y is far outside of Oregon")
  }

  if (y < 41.8075 | y > 46.3586) {
    warning("x is far outside of Oregon")
  }

  query_url <- "https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/3/query?"

  request <- httr::GET(url = URLencode(paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                              "&inSR=4269&outFields=*&returnGeometry=false",
                                              "&returnIdsOnly=false&f=GeoJSON"), reserved = FALSE))

  response <- httr::content(request, as = "text", encoding = "UTF-8")

  df <- geojsonsf::geojson_sf(response)

  if (httr::http_error(request) | NROW(df) == 0) {
    warning("Error, NA returned")
    return(data.frame(HUC12 = c(NA_character_), HUC12_Name = c(NA_character_),
                      stringsAsFactors = FALSE))
  }

  df <- dplyr::select(df, HUC12, HUC12_Name = Name)

  df <- sf::st_drop_geometry(df)
  return(df)

}
