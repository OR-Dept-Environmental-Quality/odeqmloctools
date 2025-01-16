library(readr)
library(dplyr)

# read gis txt export. Field data type based on original GIS.
ornhd.raw <- readr::read_csv(file = "data_raw/ornhd_2022_03_global_IDs.txt",
                             col_names = TRUE,
                             col_types = cols(FDate = col_character(),
                                              AU_ID = col_character(),
                                              AU_Name = col_character(),
                                              AU_WBType = col_integer(),
                                              AU_UseCode = col_character(),
                                              AU_LenMile = col_double(),
                                              AU_AreaAcr = col_double(),
                                              HUC12 = col_character(),
                                              AQWMS_NUM = col_integer(),
                                              AQWMS_TXT = col_character(),
                                              ReachCode = col_character(),
                                              FMEAS = col_double(),
                                              TMEAS = col_double(),
                                              Permanent_Identifier = col_character(),
                                              Resolution = col_integer(),
                                              GNIS_ID = col_character(),
                                              GNIS_Name = col_character(),
                                              LengthKM = col_double(),
                                              FlowDir = col_integer(),
                                              WBArea_Permanent_Identifier = col_character(),
                                              FType = col_integer(),
                                              FCode = col_integer(),
                                              MainPath = col_integer(),
                                              InNetwork = col_integer(),
                                              Visibility = col_integer(),
                                              DPAUID = col_double(),
                                              AU_Description = col_character(),
                                              AU_GNIS_Name = col_character(),
                                              AU_GNIS = col_character(),
                                              action_id = col_character(),
                                              TMDL_param = col_character(),
                                              TMDL_pollu = col_character(),
                                              Source = col_character(),
                                              period = col_character(),
                                              TMDL_scope = col_character(),
                                              Shape_Length = col_double(),
                                              GLOBALID = col_character(),
                                              FLOWDIRECTION = col_integer(),
                                              Enabled = col_integer()))

# get the Strahler stream order from the older data frame
# Once DEQ migrates to a new NHD version the StreamOrder field should be included
# in the GIS export
ornhd0 <- odeqmloctools::ornhd[, c("Permanent_Identifier", "GLOBALID", "StreamOrder")]

ornhd <- ornhd.raw %>%
  dplyr::left_join(ornhd0, by = c("Permanent_Identifier", "GLOBALID")) %>%
  dplyr::select(Permanent_Identifier, FDate, Resolution, GNIS_ID, GNIS_Name,
                LengthKM, ReachCode, FMEAS, TMEAS, FlowDir, WBArea_Permanent_Identifier,
                FType, FCode, MainPath, InNetwork, AU_ID, AU_Name, AU_Description,
                AU_WBType, AU_UseCode, AU_GNIS_Name, AU_GNIS,
                AU_LenMile, AU_AreaAcr, StreamOrder, GLOBALID) %>%
  distinct() %>%
  as.data.frame()

save(ornhd, file = "data/ornhd.RData")
