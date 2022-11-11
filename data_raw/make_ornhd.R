library(readr)
library(dplyr)

# read gis txt export
ornhd.raw <- readr::read_csv("data_raw/ornhd_2022_03.txt")

# get the Strahler stream order from the older data frame
# Once DEQ migrates to a new NHD version the StreamOrder field should be included
# in the GIS export
ornhd0 <- odeqmloctools::ornhd[, c("Permanent_Identifier", "StreamOrder")]

ornhd <- ornhd.raw %>%
  dplyr::left_join(ornhd0, by = "Permanent_Identifier") %>%
  dplyr::select(Permanent_Identifier, FDate, Resolution, GNIS_ID, GNIS_Name,
                LengthKM, ReachCode, FlowDir, WBArea_Permanent_Identifier,
                FType, FCode, MainPath, InNetwork, AU_ID, AU_Name, AU_Description,
                AU_WBType, AU_UseCode, AU_GNIS_Name, AU_GNIS,
                AU_LenMile, AU_AreaAcr, StreamOrder)  %>%
  distinct()

save(ornhd, file = "data/ornhd.RData")
