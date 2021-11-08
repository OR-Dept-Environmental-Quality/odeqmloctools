library(dplyr)
library(odeqmloctools)

df.mloc <- odeqcdr::contin_import(file = "/Users/rmichie/GitHub/odeqmloctools/test/mloc_example.xlsx",
                                  sheets = c("Monitoring_Locations"))[["Monitoring_Locations"]]

df.mloc2 <- df.mloc[complete.cases(df.mloc[,c("Latitude", "Longitude")]),]

odeqmloctools::launch_map(mloc = df.mloc2)

df2 <- df.mloc2 %>%
  select(Longitude,Latitude, County.Name, State.Code) %>%
  rowwise() %>%
  mutate(#county = get_county(x=Longitude, y=Latitude),
         #state = get_state(x=Longitude, y=Latitude),
         get_huc8code(x=Longitude, y=Latitude)),
         get_huc10code(x=Longitude, y=Latitude),
         get_huc12code(x=Longitude, y=Latitude),
         get_huc8name(x=Longitude, y=Latitude),
         get_huc10name(x=Longitude, y=Latitude),
         get_huc12name(x=Longitude, y=Latitude))



get_huc8code(x=df.mloc2$Longitude[18], y=df.mloc2$Latitude[18])

