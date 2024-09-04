#' Oregon DEQ Assessment Units
#'
#'Table of Oregon DEQ Assessment Units. The table corresponds
#'to the final assessment units published with the 2022 Integrated Report.
#'Version 03-30-2022.
#'
#' \itemize{
#'   \item AU_ID: Oregon assessment unit ID.
#'   \item AU_Name: Name of the assessment unit.
#'   \item AU_WBType: Assessment unit waterbody type code.
#'   \item AU_UseCode: Assessment unit use code.
#'   \item AQWMS_NUM: Unique ID formatted as numeric.
#'   \item AQWMS_TXT: Unique ID formatted as text.
#'   \item AU_Description: Assessment unit descriptions.
#'   \item AU_LenMile: Assessment unit length in miles.
#'   \item AU_AreaAcre: Assessment unit areas in acres if a waterbody (e.g. lake).
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
