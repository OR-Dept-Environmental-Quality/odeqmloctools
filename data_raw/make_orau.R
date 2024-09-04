
# Makes the Assessment Unit table
# Based on Final 2022 IR GIS

library(dplyr)
library(arcpullr)
library(sf)
library(odeqmloctools)


# Read from GIS from REST Service  ---------------------------------------------

# AU_base_url <- "https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services/IR_2022_Final/FeatureServer/"
# AU_SR_id <- 34
# AU_WB_id <- 43
# AU_WS_id <- 44
#
# AU_SR_fc <- get_spatial_layer(url = paste0(AU_base_url, AU_SR_id), sf_type = "esriGeometryPolyline")
# AU_WB_fc <- get_spatial_layer(url = paste0(AU_base_url, AU_WB_id), sf_type = "esriGeometryPolygon")
# AU_WS_fc <- get_spatial_layer(url = paste0(AU_base_url, AU_WS_id), sf_type = "esriGeometryPolygon")


AU_dsn <- # path to AU Features directory  "GIS/Support_Features.gdb"
AU_SR_fc <- "AU_OR_Rivers_CoastLine"
AU_WB_fc <- "AU_OR_Waterbodies_missing_flowlines"
AU_WS_fc <- "AU_OR_Watershed_Area"

AU_SR <- sf::st_read(dsn = AU_dsn,
            layer = AU_SR_fc,
            stringsAsFactors = FALSE) %>%
  sf::st_drop_geometry() %>%
  dplyr::rename(AU_LenMile = AU_LenMiles, AU_AreaAcre = AU_AreaAcr) %>%
  dplyr::select(any_of(c("AU_ID", "AU_Name", "AU_WBType", "AU_UseCode",  "AU_LenMile", "AU_AreaAcre", "HUC12", "AQWMS_NUM", "AQWMS_TXT", "AU_Description"))) %>%
  dplyr::mutate(GIS_Source = "Rivers_CoastLine")

AU_WB <- sf::st_read(dsn = AU_dsn,
                      layer = AU_WB_fc,
                      stringsAsFactors = FALSE) %>%
  sf::st_drop_geometry() %>%
  dplyr::select(any_of(c("AU_ID", "AU_Name", "AU_WBType", "AU_UseCode", "AU_LenMile", "AU_AreaAcre", "HUC12", "AQWMS_NUM", "AQWMS_TXT", "AU_Description"))) %>%
  dplyr::mutate(GIS_Source = "Waterbodies")

AU_WS <- sf::st_read(dsn = AU_dsn,
                      layer = AU_WS_fc,
                      stringsAsFactors = FALSE) %>%
  sf::st_drop_geometry() %>%
  dplyr::rename(AU_LenMile = AU_LenMiles, AU_AreaAcre = AU_AreaAcr) %>%
  dplyr::select(any_of(c("AU_ID", "AU_Name", "AU_WBType", "AU_UseCode", "AU_LenMile", "AU_AreaAcre", "HUC12", "AQWMS_NUM", "AQWMS_TXT", "AU_Description"))) %>%
  dplyr::mutate(GIS_Source = "Watershed_Area")

huc6 <- odeqmloctools::orhuc6 %>%
  dplyr::select(HUC6, HUC6_Name)

huc8 <- odeqmloctools::orhuc8 %>%
  dplyr::select(HUC8, HUC8_Name)

huc10 <- odeqmloctools::orhuc10 %>%
  dplyr::select(HUC10, HUC10_Name)

huc12 <- odeqmloctools::orhuc12 %>%
  dplyr::select(HUC12, HUC12_Name)


# Note including HUC12 and HUC12_Name due to some errors with HUC12 field
orau <- rbind(AU_SR, AU_WB, AU_WS) %>%
  dplyr::select(any_of(c("AU_ID", "AU_Name", "AU_WBType", "AU_UseCode",
                         "AU_LenMile", "AU_AreaAcre",
                         "HUC12", "AQWMS_NUM", "AQWMS_TXT", "AU_Description"))) %>%
  dplyr::distinct() %>%
  dplyr::filter(!AU_ID == "99") %>%
  dplyr::mutate(HUC6 = substr(AU_ID, 7, 12),
                HUC8 = substr(AU_ID, 7, 14),
                HUC10 = substr(AU_ID, 7, 16),
                HUC10_check = substr(HUC12, 1, 10)) %>%
  dplyr::left_join(huc6, by = "HUC6") %>%
  dplyr::left_join(huc8, by = "HUC8") %>%
  dplyr::left_join(huc10, by = "HUC10") %>%
  dplyr::left_join(huc12, by = "HUC12") %>%
  dplyr::distinct() %>%
  select(any_of(c("AU_ID", "AU_Name","AU_WBType", "AU_UseCode",
                  "AU_LenMile", "AU_AreaAcre",
                  "AQWMS_NUM", "AQWMS_TXT", "AU_Description",
                  "HUC6", "HUC8", "HUC10",
                  "HUC6_Name", "HUC8_Name", "HUC10_Name")))

save(orau, file = "data/orau.RData")



