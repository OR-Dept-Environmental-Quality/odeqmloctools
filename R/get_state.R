#' Get state abbreviation
#'
#' The function will query the Untied States Census Bureau states and county
#' TIGERweb feature service to determine the state abbreviation. The x and y
#' coordinates (longitude and latitude) are used to determine the state.
#'
#' The feature service can be accessed at \url{https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/14}.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @export
#' @return state code
get_state <- function(x, y, crs){
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_state_)
  return(df$STUSAB)
  }


#' Non vectorized version of get_state. This is what purrr calls.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value.
#' @noRd
#' @return state code
get_state_ <- function(x, y, crs){

  # Test data
  # y=42.09361
  # x=-122.3822
  # return_sf=FALSE

  if (x < -124.6155 | x > -116.3519) {
    warning("y is far outside of Oregon")
  }

  if (y < 41.8075 | y > 46.3586) {
    warning("x is far outside of Oregon")
  }

  query_url <- "https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/14/query?"

  request <- httr::GET(url = URLencode(paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                              "&inSR=4269&outFields=*&returnGeometry=false",
                                              "&returnIdsOnly=false&f=GeoJSON"), reserved = FALSE))

  response <- httr::content(request, as = "text", encoding = "UTF-8")

  df <- geojsonsf::geojson_sf(response)

  if (httr::http_error(request) | NROW(df) == 0) {
    warning("Error, NA returned")
    return(NA_character_)
  }

  return(df)
}
