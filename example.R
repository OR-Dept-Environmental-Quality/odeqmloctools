library(dplyr)
library(odeqmloctools)

df.mloc <- odeqcdr::contin_import(file = "/Users/rmichie/GitHub/odeqmloctools/test/mloc_example.xlsx",
                                  sheets = c("Monitoring_Locations"))[["Monitoring_Locations"]]

df.mloc2 <- df.mloc[complete.cases(df.mloc[,c("Latitude", "Longitude")]),]

odeqmloctools::launch_map(mloc = df.mloc2)

df.mloc3 <- df.mloc2 %>%
  select(Longitude, Latitude, County.Name, State.Code) %>%
  mutate(County.Name2 = get_county(x = Longitude, y = Latitude),
         State.Code2 = get_state(x = Longitude, y = Latitude),
         HUC8 = get_huc8code(x = Longitude, y = Latitude),
         HUC10 = get_huc10code(x = Longitude, y = Latitude),
         HUC12 = get_huc12code(x = Longitude, y = Latitude),
         HUC8_Name = get_huc8name(x = Longitude, y = Latitude),
         HUC10_Name = get_huc10name(x = Longitude, y = Latitude),
         HUC12_Name = get_huc12name(x = Longitude, y = Latitude)
)

