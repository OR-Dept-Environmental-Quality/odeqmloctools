#' Oregon DEQ Assessment Units
#'
#'Table of Oregon DEQ Assessment Units. The table corresponds
#'to the final assessment units published with the 2026 Integrated Report.
#'Version 09-26-2026.
#'
#' \itemize{
#'   \item AU_ID: Oregon assessment unit ID.
#'   \item AU_Name: Name of the assessment unit.
#'   \item AU_Description: Assessment unit descriptions.
#'   \item AU_UseCode: Assessment unit use code.
#'   \item AU_LenMiles: Assessment unit length in miles.
#'   \item AU_AreaAcre: Assessment unit area in acres if represented as a polygon waterbody (e.g. lake).
#'   \item AU_Number: Unique ID formatted as numeric.
#'   \item AU_Type: Assessment unit type.
#'   \item AU_Status: Status of the Assessment unit. Only "Active" assessment units are included in this data.
#'   \item OWRD_Basin: Oregon Water Resources Department administrative basins. Note the boundaries differ from the USGS HUCs.
#'   \item HUC6: Six digit basin code where the assessment unit is located.
#'   \item HUC6_Name: Basin name where the Assessment unit is located
#'   \item HUC8: Eight digit subbasin code where the Assessment unit is located
#'   \item HUC8_Name: Subbasin name where the assessment unit is located.
#'   \item HUC10: Ten digit watershed code where the assessment unit is located.
#'   \item HUC10_Name: Watershed name where the assessment unit is located.
#' }
#'
#' @docType data
#' @usage data(orau)
#' @keywords datasets
#' @md
#' @examples
#' au <- odeqmloctools::orau
#'

"orau"
