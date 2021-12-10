#' Get county
#'
#' The function will query the Untied States Census Bureau states and county
#' TIGERweb feature service to determine the county name. The x and y
#' coordinates (longitude and latitude) are used to select a specific county.
#'
#' The feature service can be accessed at https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/13
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as [sf::st_crs].
#' Typically entered using the numeric EPSG value. Accepts a vector.
#' @export
#' @return string of county basename
get_county <- function(x, y, crs) {
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_county_)

  return(df$BASENAME)
}


#' Non vectorized version of get_county. This is what purrr calls.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @noRd
#' @return string of county basename
get_county_ <- function(x, y, crs){

  # Test data
  # y=42.09361
  # x=-122.3822
  # crs=4326

  if (x < -124.6155 | x > -116.3519) {
    warning("y is far outside of Oregon")
  }

  if (y < 41.8075 | y > 46.3586) {
    warning("x is far outside of Oregon")
  }

  query_url <- "https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/13/query?"

  request <- httr::GET(url = URLencode(paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                              "&inSR=",crs,"&outFields=*&returnGeometry=false",
                                              "&returnIdsOnly=false&f=GeoJSON"), reserved = FALSE))

  response <- httr::content(request, as = "text", encoding = "UTF-8")

  df <- geojsonsf::geojson_sf(response)

  if (httr::http_error(request) | NROW(df) == 0) {
    warning("Error, NA returned")
    return(NA_character_)
  }

  return(df)
}
