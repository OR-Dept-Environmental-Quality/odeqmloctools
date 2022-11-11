#' Oregon DEQ NHD
#'
#'Table of National Hydrography Dataset (NHD) in Oregon. The table corresponds
#'to NHDH_OR_931v220, which is the current version used for DEQ business data.
#'Also includes Oregon's Assessment Unit fields as of 03-30-2022.
#'
#' \itemize{
#'   \item Permanent_Identifier: NHD Permanent Identifier
#'   \item FDate: Date of last feature modification.
#'   \item Resolution: Source resolution.
#'   \item GNIS_ID: Unique identifier assigned by GNIS, length 10.
#'   \item GNIS_Name: Proper name, specific term, or expression by which a
#'         particular geographic entity is known, length 65
#'   \item LengthKM: 	Length of linear feature based on Albers Equal Area,
#'         length 8.
#'   \item ReachCode: Unique identifier composed of two parts.  The first eight
#'         digits is the subbasin code as defined by FIPS 103.  The next six
#'         digits are randomly assigned, sequential numbers that are unique
#'         within a subbasin, length 14.
#'   \item FlowDir: Direction of flow relative to coordinate order, length 4.
#'   \item WBArea_Permanent_Identifier: NHD Waterbody feature Permanent Identifier
#'   \item FType: Three-digit integer value; unique identifier of a feature type.
#'   \item FCode: Five-digit integer value; composed of the feature type and
#'         combinations of characteristics and values.
#'   \item MainPath:
#'   \item InNetwork:
#'   \item AU_ID: Oregon assessment unit ID
#'   \item AU_Name: Name of the assessment unit
#'   \item AU_Description: Assessment unit descriptions
#'   \item AU_WBType: Assessment unit waterbody type code
#'   \item AU_UseCode: Assessment unit use code
#'   \item AU_GNIS_Name: Assessment unit and GNIS name concatenation.
#'   \item AU_GNIS: Same as GNIS name but with a few additional names not in NHD
#'   \item AU_LenMile: Assessment unit length in miles
#'   \item AU_AreaAcr: Assessment unit areas in acres if a waterbody (e.g. lake)
#'   \item StreamOrder: Strahler stream order number for the reach.
#' }
#'
#' @docType data
#' @usage data(ornhd)
#' @keywords datasets
#' @md
#' @examples
#' nhd <- odeqmloctools::ornhd
#'

"ornhd"
