
# Makes the Assessment Unit table

library(dplyr)
library(arcpullr)
library(sf)
library(odeqmloctools)
library(units)
library(readxl)

paths <- read_excel(path = "data_raw/paths.xlsx",
                    sheet = "paths" , col_names = TRUE,
                    col_types = c('text', 'text'))


# Read from GIS from REST Service  ---------------------------------------------

# 2022
# AU_base_url <- "https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services/IR_2022_Final/FeatureServer/"
# AU_SR_id <- 34
# AU_WB_id <- 43
# AU_WS_id <- 44
#
# AU_SR_fc <- get_spatial_layer(url = paste0(AU_base_url, AU_SR_id), sf_type = "esriGeometryPolyline")
# AU_WB_fc <- get_spatial_layer(url = paste0(AU_base_url, AU_WB_id), sf_type = "esriGeometryPolygon")
# AU_WS_fc <- get_spatial_layer(url = paste0(AU_base_url, AU_WS_id), sf_type = "esriGeometryPolygon")

# 2024
# AU_base_url <- "https://services.arcgis.com/uUvqNMGPm7axC2dD/arcgis/rest/services/Oregon_AUs/FeatureServer"
# AU_table_id <- 5

# 2026 Read GDB ----------------------------------------------------------------
# same as
# https://services.arcgis.com/uUvqNMGPm7axC2dD/arcgis/rest/services/Oregon_AU/FeatureServer

AU_dsn <- paths[paths$object=="AU_dsn", 2]
AU_tbl <- "AU_ALL_4april24"

df_AU <- sf::st_read(dsn = AU_dsn,
                     layer = AU_tbl,
                     stringsAsFactors = FALSE,
                     int64_as_string = TRUE, quiet = FALSE)

huc6 <- odeqmloctools::orhuc6 %>%
  dplyr::select(HUC6, HUC6_Name)

huc8 <- odeqmloctools::orhuc8 %>%
  dplyr::select(HUC8, HUC8_Name)

huc10 <- odeqmloctools::orhuc10 %>%
  dplyr::select(HUC10, HUC10_Name)

huc12 <- odeqmloctools::orhuc12 %>%
  dplyr::select(HUC12, HUC12_Name)

# Note, not joining using AU source HUC12 field due to a few mapping errors with HUC12 field
orau <- df_AU |>
  dplyr::filter(AU_Status == "Active") |>
  dplyr::filter(!AU_ID == "99") |>
  dplyr::mutate(HUC6 = substr(AU_ID, 7, 12),
                HUC8 = substr(AU_ID, 7, 14),
                HUC10 = substr(AU_ID, 7, 16),
                HUC10_check = HUC10 == substr(HUC12, 1, 10),
                AU_LenMiles = as.numeric(AU_LenMiles),
                AU_AreaAcre = as.numeric(AU_AreaAcr)) |>
  dplyr::left_join(huc6, by = "HUC6") |>
  dplyr::left_join(huc8, by = "HUC8") |>
  dplyr::left_join(huc10, by = "HUC10") |>
  #dplyr::left_join(huc12, by = "HUC12") |>
  select(any_of(c("AU_ID", "AU_Name", "AU_Description",
                  "AU_UseCode", "AU_LenMiles", "AU_AreaAcre",
                  "AU_Number", "AU_Type", "AU_Status",
                  "OWRD_Basin", "HUC6", "HUC6_Name",
                  "HUC8", "HUC8_Name", "HUC10", "HUC10_Name"))) |>
  dplyr::distinct()

save(orau, file = "data/orau.RData")



