# odeqmloctools
 ODEQ Monitoring Location Tools
 
A R package that provides QA/QC support for review and attribute of monitoring 
station location information. The package utilizes publicly
available REST feature services to query and extract location metadata.

## Install

```R
devtools::install_github("OR-Dept-Environmental-Quality/odeqmloctools", host = "https://api.github.com", 
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
df.mloc2 <- odeqmloctools::launch_map(mloc = df.mloc)

# Add other data once the lat/long has been reviewed in launch map()
df.mloc3 <- df.mloc2 %>%
  mutate(County.Name = get_county(x = Longitude, y = Latitude, crs = CRS),
         State.Code = get_state(x = Longitude, y = Latitude, crs = CRS),
         HUC8 = get_huc8code(x = Longitude, y = Latitude, crs = CRS),
         HUC10 = get_huc10code(x = Longitude, y = Latitude, crs = CRS),
         HUC12 = get_huc12code(x = Longitude, y = Latitude, crs = CRS),
         HUC8_Name = get_huc8name(x = Longitude, y = Latitude, crs = CRS),
         HUC10_Name = get_huc10name(x = Longitude, y = Latitude, crs = CRS),
         HUC12_Name = get_huc12name(x = Longitude, y = Latitude, crs = CRS),
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
