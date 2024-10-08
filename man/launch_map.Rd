% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/launch_map.R
\name{launch_map}
\alias{launch_map}
\title{Launch a web map in a browser to review and edit monitoring location information}
\usage{
launch_map(mloc, px_ht = 470, hide_layers = c("LLID Streams", "Hydrography"))
}
\arguments{
\item{mloc}{Data frame of the monitoring location information.
Required columns are 'Monitoring.Location.ID', 'Monitoring.Location.Name',
'Latitude', and 'Longitude'. Other columns are optional but will be added
if not present and the values set to NA. The full set of mloc column names
can be generated using \code{\link[odeqcdr:cols_mloc]{odeqcdr::cols_mloc}}
or as a data frame using \code{\link{df_mloc}}. "Snap.Lat" and "Snap.Long"
"HUC8", "HUC8_Name", "HUC10", "HUC10_Name", "HUC12", "HUC12_Name",
"AU_ID", "AU_Name", "AU_GNIS" are added.}

\item{px_ht}{Height of the map in pixels. Default is 470 which fits on most
standard laptop screens. The minimum height is 300 pixels.}

\item{hide_layers}{vector of the map layer names that remain hidden by default.
       They can still be turned on manually in the map view.
The default is set to c("LLID Streams", "Hydrography")). To show all
layers use hide_layers = NULL.
Options include any of the following: "Review Stations", "AWQMS Stations",
"NHD Streams", "LLID Streams", "Hydrography", and "Oregon Imagery".}
}
\value{
Launches a leaflet map within a Shiny app. Returns mloc data frame with any saved changes on app close.
}
\description{
Launch a web map in a browser to review and edit monitoring location information
}
