#' Oregon Beneficial Use and Water Quality Standard Codes
#'
#'Table of Oregon beneficial Use and water quality standard designation codes as
#'applied to the National Hydrography Dataset (NHD). The NHD version corresponds
#'to NHDH_OR_931v220. The table was exported from the GIS feature called
#'"Oregon_Standards" and represents mapping as of 03-07-2024. The GIS feature service can be found at
#'https://arcgis.deq.state.or.us/arcgis/rest/services/WQ/WQStandards_WM/MapServer.
#'See Oregon DEQ Georeferencing Classification Codes document for meaning of Beneficial
#'Use and Water Quality Standard Codes.
#'
#' \itemize{
#'   \item Permanent_Identifier: NHD Permanent Identifier
#'   \item GNIS_ID: Unique identifier assigned by GNIS, length 10.
#'   \item GNIS_Name: Proper name, specific term, or expression by which a
#'         particular geographic entity is known.
#'   \item WBArea_Permanent_Identifier: NHD Waterbody feature Permanent Identifier
#'   \item ReachCode: Unique identifier composed of two parts.  The first eight
#'         digits is the subbasin code as defined by FIPS 103.  The next six
#'         digits are randomly assigned, sequential numbers that are unique
#'         within a subbasin.
#'   \item FishCode: Designated Aquatic Life Fish Use Subcategories (Temperature)
#'   \item SpawnCode: Designated Seasonal Spawning Date Ranges (Temperature)
#'   \item WaterTypeCode: Water Type - Salinity-based water type designation
#'   \item WaterBodyCode: Water Body Type - Functional or morphologic water body type designation
#'   \item BacteriaCode: Designated Contact Recreation and Shellfish Harvest Use Subcategories (Bacteria)
#'   \item DO_code: Designated Aquatic Life Use Subcategories (Dissolved Oxygen).
#'   \item ben_use_code: Beneficial Use Designations – Designated beneficial uses of the waterbody
#'   \item pH_code: Designated pH standards (pH)
#'   \item DO_SpawnCode: Designated Seasonal Spawning Date Ranges (Dissolved Oxygen)
#'   \item TempCode: Temperature standard applied for Clean Water Act purposes.
#'   \item SpawnDates: The date period when spawning use applies.
#' }
#'
#' @docType data
#' @usage data(orwqs)
#' @keywords datasets
#' @md
#' @examples
#' wqs <- odeqmloctools::orwqs

"orwqs"
