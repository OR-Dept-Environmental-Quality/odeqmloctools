# odeqmloctools
 ODEQ Monitoring Location Tools
 
A R package that provides QA/QC support for review and attribute of monitoring 
station location information. The package utilizes publicly
available REST feature services to query and extract location metadata.

## Install

```R
library(remotes)

remotes::install_github(repo = "OR-Dept-Environmental-Quality/odeqmloctools", 
                        host = "https://api.github.com", 
                        dependencies = TRUE, force = TRUE, upgrade = "never")
```
## Example

```R
library(dplyr)
library(odeqmloctools)

# For this example pretend to only start with certain columns. Add CRS column.
df.mloc <- odeqmloctools::mloc_example() %>%
  dplyr::select(Monitoring.Location.ID, Monitoring.Location.Name, Longitude, Latitude, Horizontal.Datum) %>%
  dplyr::mutate(CRS = dplyr::case_when(Horizontal.Datum == "WGS84" ~ 4326,
                                       Horizontal.Datum == "NAD83" ~ 4269,
                                       TRUE ~ 4269))

# Review and edit the information in the map
df.mloc2 <- odeqmloctools::launch_map(mloc = df.mloc,px_ht = 470, 
                                      hide_layers = c("LLID Streams", "Hydrography"),
                                      col_mapping = c(Monitoring.Location.ID = "Monitoring.Location.ID",
                                                      Monitoring.Location.Name = "Monitoring.Location.Name",
                                                      Latitude = "Latitude",
                                                      Longitude = "Longitude",
                                                      Monitoring.Location.Status.ID = "Monitoring.Location.Status.ID",
                                                      Monitoring.Location.Type = "Monitoring.Location.Type",
                                                      Permanent.Identifier = "Permanent.Identifier",
                                                      Reachcode = "Reachcode",
                                                      Measure = "Measure",
                                                      GNIS_Name = "GNIS_Name",
                                                      River.Mile = "River.Mile",
                                                      LLID = "LLID",
                                                      Alternate.ID.1 = "Alternate.ID.1",
                                                      Alternate.Context.1 = "Alternate.Context.1",
                                                      HUC6_Name = "HUC6_Name",
                                                      HUC8_Name = "HUC8_Name",
                                                      HUC10_Name = "HUC10_Name",
                                                      HUC12_Name = "HUC12_Name",
                                                      HUC6 = "HUC6",
                                                      HUC8 = "HUC8",
                                                      HUC10 = "HUC10",
                                                      HUC12 = "HUC12",
                                                      AU_ID = "AU_ID",
                                                      AU_Name = "AU_Name",
                                                      Snap.Lat = "Snap.Lat",
                                                      Snap.Long = "Snap.Long"))

# Add other data once the lat/long has been reviewed in launch map()
df.mloc3 <- df.mloc2 %>%
  mutate(County.Name = get_county(x = Longitude, y = Latitude, crs = CRS),
         State.Code = get_state(x = Longitude, y = Latitude, crs = CRS),
         EcoRegion2 = get_eco2name(x = Longitude, y = Latitude, crs = CRS),
         EcoRegion3 = get_eco3code(x = Longitude, y = Latitude, crs = CRS),
         EcoRegion4 = get_eco4code(x = Longitude, y = Latitude, crs = CRS))

#-- More examples ---

# Get a data frame of most current NHD High from USGS. Includes measure value based on snapping x/y.
df.nhd_usgs <- df.mloc3 %>%
  get_nhd_df(x = Longitude, y = Latitude, crs = CRS, search_dist = 100, service = "USGS")

# Get a data frame of NHD plus HR info
df.nhdplus <- df.mloc3 %>%
  get_nhdplus_df(x = Longitude, y = Latitude, crs = CRS, search_dist = 100)
  
```
