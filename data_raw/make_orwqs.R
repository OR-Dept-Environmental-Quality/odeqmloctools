library(readr)
library(dplyr)

# text file is export of WQS GIS feature

# read gis txt export. Field data type based on original GIS
orwqs.raw <- readr::read_csv(file = "data_raw/orwqs_2024_03.txt",
                             col_names = TRUE,
                             col_types = cols(Permanent_Identifier = col_character(),
                                              FDate = col_character(),
                                              Resolution = col_integer(),
                                              GNIS_ID = col_character(),
                                              GNIS_Name = col_character(),
                                              LengthKM = col_double(),
                                              ReachCode = col_character(),
                                              FlowDir = col_integer(),
                                              WBArea_Permanent_Identifier = col_character(),
                                              FType = col_integer(),
                                              FCode = col_integer(),
                                              MainPath = col_integer(),
                                              InNetwork = col_integer(),
                                              VisibilityFilter = col_integer(),
                                              FMEAS = col_double(),
                                              TMEAS = col_double(),
                                              FishCode = col_character(),
                                              SpawnCode = col_character(),
                                              WaterTypeCode = col_character(),
                                              WaterBodyCode = col_character(),
                                              BacteriaCode = col_character(),
                                              DO_code = col_character(),
                                              ben_use_code = col_character(),
                                              pH_code = col_character(),
                                              DO_SpawnCode = col_character(),
                                              TempCode = col_character(),
                                              UseCode = col_character(),
                                              TempFix = col_integer(),
                                              SpawnDates = col_character(),
                                              Shape_Length = col_double()))

orwqs <- orwqs.raw %>%
  select(Permanent_Identifier, GNIS_ID, GNIS_Name, WBArea_Permanent_Identifier, ReachCode, FishCode, SpawnCode,
         WaterTypeCode, WaterBodyCode, BacteriaCode, DO_code, ben_use_code,
         pH_code, DO_SpawnCode, TempCode, SpawnDates) %>%
  distinct() %>%
  as.data.frame()

save(orwqs, file = "data/orwqs.RData")
