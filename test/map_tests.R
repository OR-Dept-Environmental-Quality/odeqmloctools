
y<- 42.09361
x<- -122.3822

library(leaflet)
library(leaflet.esri)
library(sf)

map <- leaflet::leaflet(options = leaflet::leafletOptions(minZoom = 1, maxZoom = 22)) %>%
  leaflet::setView(lng=x, lat=y, zoom = 8) %>%
  leafem::addMouseCoordinates() %>%
  leaflet::addMapPane("Base", zIndex = 150) %>%
  leaflet::addMapPane("Aerial2", zIndex = 300) %>%
  leaflet::addMapPane("Hydro", zIndex = 302) %>%
  leaflet::addMapPane("huc8", zIndex = 350) %>%
  leaflet::addMapPane("huc10", zIndex = 351) %>%
  leaflet::addMapPane("huc12", zIndex = 352) %>%
  leaflet::addMapPane("Points_AWQMS", zIndex= 405) %>%
  leaflet::addMapPane("Select", zIndex = 410) %>%
  leaflet::addMapPane("Lines", zIndex = 420) %>%
  leaflet::addMapPane("Points_Review", zIndex= 600) %>%
  leaflet.esri::addEsriTiledMapLayer(url =  "https://basemap.nationalmap.gov/arcgis/rest/services/USGSShadedReliefOnly/MapServer",
                                     options = leaflet::leafletOptions(pane="Base")) %>%
  leaflet::addTiles(urlTemplate = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    options= leaflet::tileOptions(opacity=0.7)) %>%
  leaflet.esri::addEsriImageMapLayer(url="https://imagery.oregonexplorer.info/arcgis/rest/services/OSIP_2018/OSIP_2018_WM/ImageServer",
                                     group = "Oregon Imagery",
                                     options = leaflet::leafletOptions(pane="Aerial2")) %>%
  leaflet.esri::addEsriImageMapLayer(url="https://imagery.oregonexplorer.info/arcgis/rest/services/OSIP_2017/OSIP_2017_WM/ImageServer",
                                     group = "Oregon Imagery",
                                     options = leaflet::leafletOptions(pane="Aerial2")) %>%
  leaflet::addWMSTiles(baseUrl="https://basemap.nationalmap.gov/arcgis/services/USGSHydroCached/MapServer/WmsServer",
                       group = "Hydrography",
                       options = leaflet::WMSTileOptions(format = "image/png",
                                                         transparent = TRUE,
                                                         pane= "Hydro"),
                       attribution = '<a href="https://basemap.nationalmap.gov/arcgis/rest/services/USGSHydroCached/MapServer">USGS The National Map: National Hydrography Dataset.</a>',
                       layers = "0") %>%
  leaflet.esri::addEsriFeatureLayer(url="https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/1",
                                    group = "HUC8",
                                    options = leaflet::leafletOptions(pane="huc8", minZoom = 8),
                                    weight = 4,
                                    color = "black",
                                    opacity = 3,
                                    fillColor = "transparent",
                                    fillOpacity = 0,
                                    popupProperty = htmlwidgets::JS(paste0('function(feature){var props = feature.properties; return \"',
                                                                           '<b>HUC8 Name:</b> \"+props.Name+\"',
                                                                           '<br><b>HUC8:</b> \"+props.HUC8+\"',
                                                                           ' \"}'))
                                    ) %>%
  leaflet.esri::addEsriFeatureLayer(url="https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/2",
                                    group = "HUC10",
                                    options = leaflet::leafletOptions(pane="huc10", minZoom = 8),
                                    weight = 3,
                                    color = "black",
                                    opacity = 3,
                                    fillColor = "transparent",
                                    fillOpacity = 0,
                                    popupProperty = htmlwidgets::JS(paste0('function(feature){var props = feature.properties; return \"',
                                                                           '<b>HUC10 Name:</b> \"+props.Name+\"',
                                                                           '<br><b>HUC10:</b> \"+props.HUC10+\"',
                                                                           ' \"}'))
  ) %>%
  leaflet.esri::addEsriFeatureLayer(url="https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WBD/MapServer/3",
                                    group = "HUC12",
                                    options = leaflet::leafletOptions(pane="huc12", minZoom = 12),
                                    weight = 1,
                                    color = "black",
                                    opacity = 3,
                                    fillColor = "transparent",
                                    fillOpacity = 0,
                                    popupProperty = htmlwidgets::JS(paste0('function(feature){var props = feature.properties; return \"',
                                                                           '<b>HUC12 Name:</b> \"+props.Name+\"',
                                                                           '<br><b>HUC12:</b> \"+props.HUC12+\"',
                                                                           ' \"}'))
  )

map <- map %>%
  leaflet::addLayersControl(overlayGroups = c("Review Stations",
                                              "AWQMS Stations",
                                              "NHD Streams",
                                              "LLID Streams",
                                              "HUC8",
                                              "HUC10",
                                              "HUC12",
                                              "Hydrography",
                                              "Oregon Imagery"),
                            options = leaflet::layersControlOptions(collapsed = FALSE)) %>%
  leaflet::addEasyButton(leaflet::easyButton(
    icon = "fa-globe",
    title = "Zoom to all Review Monitoring Statons",
    onClick = htmlwidgets::JS("function(btn, map){
                var groupLayer = map.layerManager.getLayerGroup('Review Stations');
                map.fitBounds(groupLayer.getBounds());
                 }"))) %>%
  leaflet::addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>%
  leaflet::hideGroup(c("LLID Streams","Hydrography"))

map
