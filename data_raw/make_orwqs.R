library(readr)
library(dplyr)

# read gis txt export
orwqs.raw <- readr::read_csv("data_raw/orwqs_2022_11.txt")

orwqs <- orwqs.raw %>%
  select(Permanent_Identifier, WBArea_Permanent_Identifier, FishCode, SpawnCode,
         WaterTypeCode, WaterBodyCode, BacteriaCode, DO_code, ben_use_code,
         pH_code, DO_SpawnCode, TempCode) %>%
  distinct()

save(orwqs, file = "data/orwqs.RData")
