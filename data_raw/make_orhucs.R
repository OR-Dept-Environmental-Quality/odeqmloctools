
# Makes the HUC tables

library(dplyr)
library(readxl)

# Read from xlsx ---------------------------------------------------------------

orhuc6 <- readxl::read_excel(path = "data_raw/OR_WBD_HUC6-HUC12_2013.08.29.xlsx",
                              sheet = "HUC6-Basins" , col_names = TRUE,
                              na = c("", "NA"),
                              col_types = c("text", "text", "text")) %>%
  select(HUC6 = HUC6, HUC6_Name = "Basin Name", States) %>%
  as.data.frame()

orhuc8 <- readxl::read_excel(path = "data_raw/OR_WBD_HUC6-HUC12_2013.08.29.xlsx",
                           sheet = "HUC8-Subbains" , col_names = TRUE,
                           na = c("", "NA"),
                           col_types = c("text", "text", "text", "text", "text")) %>%
  select(HUC8 = HUC8, HUC8_Name = "Subbasin Name", States) %>%
  as.data.frame()


orhuc10 <- readxl::read_excel(path = "data_raw/OR_WBD_HUC6-HUC12_2013.08.29.xlsx",
                           sheet = "HUC10-Watersheds" , col_names = TRUE,
                           na = c("", "NA"),
                           col_types = c("text", "text", "text", "text", "text",
                                         "text", "text")) %>%
  select(HUC10 = HUC10, HUC10_Name = "Watershed Name", States) %>%
  as.data.frame()


orhuc12 <- readxl::read_excel(path = "data_raw/OR_WBD_HUC6-HUC12_2013.08.29.xlsx",
                            sheet = "HUC12-Subwatersheds" , col_names = TRUE,
                            na = c("", "NA"),
                            col_types = c("text", "text", "text", "text", "text",
                                          "text", "text", "text", "text")) %>%
  select(HUC12 = HUC12, HUC12_Name = "Subwatershed Name", States) %>%
  as.data.frame()


orhuc6_12 <- readxl::read_excel(path = "data_raw/OR_WBD_HUC6-HUC12_2013.08.29.xlsx",
                            sheet = "HUC6-HUC12" , col_names = TRUE,
                            na = c("", "NA"),
                            col_types = c("text", "text", "text", "text",
                                          "text", "text", "text", "text")) %>%
  select(HUC6 = HUC6, HUC6_Name = "Basin Name",
         HUC8 = HUC8, HUC8_Name = "Subbasin Name",
         HUC10 = HUC10, HUC10_Name = "Watershed Name",
         HUC12 = HUC12, HUC12_Name = "Subwatershed Name") %>%
  as.data.frame()

save(orhuc6, file = "data/orhuc6.RData")
save(orhuc8, file = "data/orhuc8.RData")
save(orhuc10, file = "data/orhuc10.RData")
save(orhuc12, file = "data/orhuc12.RData")
save(orhuc6_12, file = "data/orhuc6_12.RData")



