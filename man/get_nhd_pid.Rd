% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_nhd_pid.R
\name{get_nhd_pid}
\alias{get_nhd_pid}
\title{Get NHD Permanent_Identifier}
\usage{
get_nhd_pid(x, y, crs, search_dist = 100)
}
\arguments{
\item{x}{The longitude in decimal degrees. Required. Accepts a vector.}

\item{y}{The latitude in decimal degrees. Required. Accepts a vector.}

\item{crs}{The coordinate reference system for x and y. Same format as
\code{\link[sf:st_crs]{sf::st_crs}}. Typically entered using
the numeric EPSG value. Accepts a vector.}

\item{search_dist}{The maximum search distance around x and y to look for
features. Measured in meters. Default is 100.}
}
\value{
Permanent_Identifier
}
\description{
The function will query Oregon DEQ's NHD feature service to determine the
Permanent_Identifier value along a target NHD flowline. The x and y coordinates
(longitude and latitude) are used to select the flowline. The permanent_Identifier
returned is based on the flowline that is closest to the coordinates.
}
\details{
The feature service can be accessed at \url{https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/NHDH_ORDEQ/MapServer/1}.
The feature service is based on NHDH_OR_931v220.
}
