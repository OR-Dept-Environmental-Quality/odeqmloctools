#' Get Ecoregion Level III
#'
#' The function will query the United States Environmental Protection Agency
#' Shared Enterprise Geodata and Services (SEGS) web service service to determine
#' the Ecoregion Level III. The x and y coordinates (longitude and latitude)
#' are used to select a specific ecoregion.
#'
#' The feature service can be accessed at \url{https://geodata.epa.gov/arcgis/rest/services/ORD/USEPA_Ecoregions_Level_III_and_IV/MapServer/11}.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @seealso \code{\link{get_eco3code}}, \code{\link{get_eco3name}}
#' @export
#' @return data frame from feature service
get_eco3 <- function(x, y, crs) {
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_eco3_)

  return(df)
}

#' Get Ecoregion Level III code
#'
#' The function will query the United States Environmental Protection Agency
#' Shared Enterprise Geodata and Services (SEGS) web service service to determine
#' the Ecoregion Level III code. The x and y coordinates (longitude and latitude)
#' are used to select a specific ecoregion.
#'
#' The feature service can be accessed at \url{https://geodata.epa.gov/arcgis/rest/services/ORD/USEPA_Ecoregions_Level_III_and_IV/MapServer/11}.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @seealso \code{\link{get_eco3}}, \code{\link{get_eco3name}}
#' @export
#' @return Ecoregion Level III code in character format
get_eco3code <- function(x, y, crs) {
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_eco3_)
  return(df$US_L3CODE)
}


#' Get Ecoregion Level III name
#'
#' The function will query the United States Environmental Protection Agency
#' Shared Enterprise Geodata and Services (SEGS) web service service to determine
#' the Ecoregion Level III name. The x and y coordinates (longitude and latitude)
#' are used to select a specific ecoregion.
#'
#' The feature service can be accessed at \url{https://geodata.epa.gov/arcgis/rest/services/ORD/USEPA_Ecoregions_Level_III_and_IV/MapServer/11}.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value. Accepts a vector.
#' @seealso \code{\link{get_eco3}}, \code{\link{get_eco3code}}
#' @export
#' @return The Ecoregion Level III name
get_eco3name <- function(x, y, crs) {
  df <- purrr::pmap_dfr(list(x, y, crs), .f = get_eco3_)
  return(df$US_L3NAME)
}


#' Non vectorized version of get_eco3. This is what purrr calls.
#'
#' @param x The longitude in decimal degrees.
#' @param y The latitude in decimal degrees.
#' @param crs The coordinate reference system for x and y. Same format as
#'            \code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
#'            the numeric EPSG value.
#' @noRd
#' @return data frame from feature service
get_eco3_ <- function(x, y, crs){

  # Test data
  # y <- 42.09361
  # x <- -122.3822
  # crs <- 4326

  if (x < -124.6155 | x > -116.3519) {
    warning("y is far outside of Oregon")
  }

  if (y < 41.8075 | y > 46.3586) {
    warning("x is far outside of Oregon")
  }

  query_url <- "https://geodata.epa.gov/arcgis/rest/services/ORD/USEPA_Ecoregions_Level_III_and_IV/MapServer/11/query?"

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
