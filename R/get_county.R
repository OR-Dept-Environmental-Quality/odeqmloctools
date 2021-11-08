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
#' @export
#' @return sf object or string of county basename

get_county <- function(x, y){

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

  query_url <- "https://tigerweb.geo.census.gov/arcgis/rest/services/TIGERweb/State_County/MapServer/13/query?"

  # get the HUC8
  request <- httr::GET(url = paste0(query_url, "geometryType=esriGeometryPoint&geometry=",x,",",y,
                                    "&inSR=4269&&outFields=*&returnGeometry=false",
                                    "&returnIdsOnly=false&f=GeoJSON"))
  response <- httr::content(request, as = "text", encoding = "UTF-8")

  df <- geojsonsf::geojson_sf(response)

  return(df$BASENAME)
}



