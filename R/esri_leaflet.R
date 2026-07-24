esri_leaflet_dependency <- function() {

  htmltools::htmlDependency(name = "esri-leaflet",
                            version = "3.0.19",
                            src = "htmlwidgets/lib/esri-leaflet",
                            package = "odeqmloctools",
                            script = "esri-leaflet.js",
                            all_files = FALSE)
  }

esri_leaflet_binding_dependency <- function() {

  htmltools::htmlDependency(name = "odeqmloctools-esri-leaflet-binding",
                            version = as.character(base::getNamespaceVersion("odeqmloctools")),
                            src = "htmlwidgets",
                            package = "odeqmloctools",
                            script = "odeqmloctools-esri-leaflet-binding.js",
                            all_files = FALSE)
  }

#' Adds an ArcGIS feature layer to a Leaflet map.
#'
#' This function adds a single hosted feature service layer from an ArcGIS Feature
#' Service or Map Service to an R Leaflet map.
#'
#' Esri's 'esri-leaflet' library is bundled in this package and manages the feature
#' requests, loading, caching, and map attribution along with the required
#' 'Powered by ESRI' attribution.
#'
#' @param map The leaflet map widget
#' @param url url of the \href{http://resources.arcgis.com/en/help/arcgis-rest-api/index.html#/Feature_Service/02r3000000z2000000/}{FeatureService} or \href{http://resources.arcgis.com/en/help/arcgis-rest-api/index.html#/Map_Service/02r3000000w2000000/}{MapService}.
#' @param options Leaflet options created with \code{\link[leaflet]{leafletOptions}()}.
#' This wrapper uses \code{minZoom}, \code{maxZoom}, and \code{pane}.
#' @param layerId A unique ID for the layer.
#' @param group The name of the group this layer should be added to.
#'   This has the same meaning as the `group` argument used by leaflet's \code{\link{addTiles}})
#' @param markerOptions Marker options created with \code{\link[leaflet]{markerOptions}()}.
#' These options apply to point features.
#' @param labelProperty The property to use for the label.
#' You can also pass in a JS function that takes in a feature and returns a text/HTML content.
#' @param labelOptions Tooltip options created with \code{\link[leaflet]{labelOptions}()}.
#' @param popupProperty A JavaScript function created with
#' \code{\link[htmlwidgets]{JS}()} that accepts a GeoJSON feature and returns
#' its popup content. Use \code{NULL} for no popup
#' @param popupOptions Popup options created with \code{\link[leaflet]{popupOptions}()}.
#' @param stroke whether to draw stroke along the path (e.g. the borders of
#'   polygons or circles)
#' @param color stroke color
#' @param weight stroke width in pixels
#' @param opacity stroke opacity
#' @param fill whether to fill the path with color (e.g. filling on polygons or
#'   circles)
#' @param fillColor fill color
#' @param fillOpacity fill opacity
#' @param dashArray A string that defines the stroke
#'   \href{https://developer.mozilla.org/docs/Web/SVG/Attribute/stroke-dasharray}{dash pattern}
#' @param smoothFactor Numeric. The amount of simplification applied to
#' polylines at each zoom level. Larger values improve rendering performance
#' while reducing geometric detail.
#' @param noClip Logical. Whether to disable polyline clipping.
#' @param pathOptions Additional path options created with
#' \code{\link[leaflet]{pathOptions}()}. The corresponding explicit styling
#' @param highlightOptions Highlighting options created with
#' \code{\link[leaflet]{highlightOptions}()}, or \code{NULL} to disable
#' mouseover highlighting. Highlighting applies only to layers that implement
#' Leaflet's \code{setStyle()} method.
#' @param fields A character vector containing the service fields to request.
#' Include the service object identifier, normally \code{OBJECTID} or
#' \code{FID}. \code{NULL} uses the Esri Leaflet default and returns all fields.
#' @param where A character string containing an ArcGIS SQL expression used to
#' filter features on the server. Default is NULL.
#' @param cacheLayers Logical. Whether Esri Leaflet should retain features in
#' its internal cache after they leave the visible map. Default is NULL which uses the
#' Esri default.
#' @param from Beginning of a time range for a time enabled feature layer.
#' Use with \code{to}. \code{NULL} disables the option.
#' @param to End of a time range for a time enabled feature layer. Use with
#' \code{from}. \code{NULL} disables the option.
#' @param timeField A character field name, or a named list containing
#' \code{start} and \code{end} field names, used for time filtering.
#' \code{NULL} disables the option.
#' @param timeFilterMode Character. Either \code{"server"} or \code{"client"}.
#' \code{NULL} uses the Esri Leaflet default of server filtering.
#' @param simplifyFactor Numeric. The amount by which Esri Leaflet simplifies
#' requested line and polygon geometry. \code{NULL} uses the Esri Leaflet default.
#' @param precision Integer. Number of coordinate decimal places requested
#' from the service. \code{NULL} uses the Esri Leaflet default.
#' @param token Character authentication token supplied with service requests,
#' or \code{NULL} for no token.
#' @param proxy Character URL of an ArcGIS request proxy, or \code{NULL} for
#' direct requests.
#' @param useCors Logical. Whether the service should use cross origin requests.
#' \code{NULL} uses Esri Leaflet's detected default.
#' @param renderer A Leaflet vector renderer, normally
#' \code{L.svg()} or \code{L.canvas()}, supplied as a JavaScript value.
#' \code{NULL} uses the Leaflet default renderer.
#' @return The leaflet map widget with the Esri feature layer call and JavaScript dependencies attached.
#' @keywords internal
add_esri_feature_layer <- function(map,
                                   url,
                                   options = leaflet::leafletOptions(),
                                   layerId,
                                   group,
                                   markerOptions = leaflet::markerOptions(),
                                   labelProperty = NULL,
                                   labelOptions = leaflet::labelOptions(),
                                   popupProperty = NULL,
                                   popupOptions = leaflet::popupOptions(),
                                   stroke = TRUE,
                                   color = "#03F",
                                   weight = 5,
                                   opacity = 0.5,
                                   fill = TRUE,
                                   fillColor = "#03F",
                                   fillOpacity = 0.2,
                                   dashArray = NULL,
                                   smoothFactor = 1,
                                   noClip = FALSE,
                                   pathOptions = leaflet::pathOptions(),
                                   highlightOptions = NULL,
                                   fields = NULL,
                                   where = NULL,
                                   cacheLayers = NULL,
                                   from = NULL,
                                   to = NULL,
                                   timeField = NULL,
                                   timeFilterMode = NULL,
                                   simplifyFactor = NULL,
                                   precision = NULL,
                                   token = NULL,
                                   proxy = NULL,
                                   useCors = NULL,
                                   renderer = NULL) {

  # filter the NULL option parameters before sending to javascript
  feature_options <- leaflet::filterNULL(c(
    options[intersect(names(options), c("minZoom", "maxZoom", "pane"))],
    list(fields = fields,
         where = where,
         cacheLayers = cacheLayers,
         from = from,
         to = to,
         timeField = timeField,
         timeFilterMode = timeFilterMode,
         simplifyFactor = simplifyFactor,
         precision = precision,
         token = token,
         proxy = proxy,
         useCors = useCors,
         renderer = renderer)))

  map$dependencies[[length(map$dependencies) + 1]] <- esri_leaflet_dependency()
  map$dependencies[[length(map$dependencies) + 1]] <- esri_leaflet_binding_dependency()

   leaflet::invokeMethod(map, NULL, "addEsriFeatureLayer",
                         url, feature_options, layerId, group, markerOptions,
                         labelProperty, labelOptions, popupProperty, popupOptions,
                         stroke, color, weight, opacity, fill, fillColor, fillOpacity,
                         dashArray, smoothFactor, noClip, pathOptions,
                         highlightOptions)
   }
