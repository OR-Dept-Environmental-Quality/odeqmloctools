// This binding connects the R add_esri_feature_layer() function to
// L.esri.featureLayer() in the esri-leaflet.js library, which adds ArcGIS feature
// layers to Leaflet. This binding manages attribution, labels, popups,
// highlighting, and passes feature click events to shiny for each ArcGIS
// feature layer. ChatGPT 5.5 was used to review and debug this binding code
// during development.

(function() {

  LeafletWidget.methods.addEsriFeatureLayer = function(
  url, options, layerId, group, markerOptions,
  labelProperty, labelOptions, popupProperty, popupOptions,
  stroke, color, weight, opacity, fill, fillColor, fillOpacity,
  dashArray, smoothFactor, noClip, pathOptions,
  highlightOptions) {

  var map = this;
  var pane = options.pane;

  if (!map.odeqmloctoolsEsriAttributionAdded) {
    map.attributionControl.addAttribution(
      'Powered by <a href="https://www.esri.com">Esri</a>'
    );
    map.odeqmloctoolsEsriAttributionAdded = true;
  }

  markerOptions = Object.assign({}, markerOptions);
  pathOptions = Object.assign({}, pathOptions, {
    stroke: stroke,
    color: color,
    weight: weight,
    opacity: opacity,
    fill: fill,
    fillColor: fillColor,
    fillOpacity: fillOpacity,
    dashArray: dashArray,
    smoothFactor: smoothFactor,
    noClip: noClip
  });

  if (pane) {
    markerOptions.pane = pane;
    pathOptions.pane = pane;
  }

  var layerOptions = Object.assign({
    url: url,

    style: function() {
      return pathOptions;
    },

    pointToLayer: function(feature, latlng) {
      return L.marker(latlng, markerOptions);
    },

    onEachFeature: function(feature, layer) {
      if (labelProperty) {
        layer.bindTooltip(labelProperty(feature), labelOptions);

      }

      if (popupProperty) {
        layer.bindPopup(popupProperty(feature), popupOptions);

      }

      if (highlightOptions && layer.setStyle) {
        var highlightStyle = Object.assign({}, highlightOptions);
        var bringToFront = highlightStyle.bringToFront;
        var sendToBack = highlightStyle.sendToBack;

        delete highlightStyle.bringToFront;
        delete highlightStyle.sendToBack;

        layer.on("mouseover", function() {
          layer.setStyle(highlightStyle);
          if (bringToFront && layer.bringToFront) {
            layer.bringToFront();
          }
        });

        layer.on("mouseout", function() {
          layer.setStyle(pathOptions);
          if (sendToBack && layer.bringToBack) {
            layer.bringToBack();
          }
        });
      }

      layer.on("click", function(event) {
        if (!HTMLWidgets.shinyMode) {
          return;
        }

        var latlng = event.latlng;
        var value = {
          id: layerId,
          group: group,
          featureId: feature.id,
          properties: feature.properties
        };

        if (!latlng && event.target.getLatLng) {
          latlng = event.target.getLatLng();
        }

        if (latlng) {
          value.lat = latlng.lat;
          value.lng = latlng.lng;
        }

        Shiny.setInputValue(
          map.id + "_geojson_click",
          value,
          { priority: "event" }
        );
      });
    }
  }, options);

  var featureLayer = L.esri.featureLayer(layerOptions);
  map.layerManager.addLayer(featureLayer, "geojson", layerId, group);
  };
  })();


