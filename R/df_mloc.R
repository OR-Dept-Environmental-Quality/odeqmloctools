#' Monitoring Locations dataframe
#'
#' Retrieve a dataframe with column names for the Monitoring Locations worksheet
#' in Oregon DEQ's continuous data submission template xlsx file v2.03.
#' Returns one row of data with all values set to NA.
#' Includes internal staff columns: "Reachcode", "Measure", "LLID", "River Mile",
#' "Permanent Identifier", "Monitoring Location Status ID", and
#' "Monitoring Location Status Comment".
#' @export
#' @return dataframe
#'
df_mloc <- function() {

  df <- data.frame(Monitoring.Location.ID = NA_character_,
                   Monitoring.Location.Name = NA_character_,
                   Monitoring.Location.Type = NA_character_,
                   Latitude = NA_real_,
                   Longitude = NA_real_,
                   Horizontal.Datum = NA_character_,
                   Coordinate.Collection.Method = NA_character_,
                   Source.Map.Scale = NA_character_,
                   Monitoring.Location.Description = NA_character_,
                   Tribal.Land = NA_character_,
                   Tribal.Land.Name = NA_character_,
                   County.Name = NA_character_,
                   State.Code = NA_character_,
                   HUC.8.Code = NA_character_,
                   Date.Established = lubridate::NA_POSIXct_,
                   Monitoring.Location.Comments = NA_character_,
                   Alternate.ID.1 = NA_character_,
                   Alternate.Context.1 = NA_character_,
                   Alternate.ID.2 = NA_character_,
                   Alternate.Context.2 = NA_character_,
                   Alternate.ID.3 = NA_character_,
                   Alternate.Context.3 = NA_character_,
                   Reachcode = NA_character_,
                   Measure = NA_real_,
                   LLID = NA_character_,
                   River.Mile = NA_real_,
                   Permanent.Identifier = NA_character_,
                   Monitoring.Location.Status.ID = NA_character_,
                   Monitoring.Location.Status.Comment = NA_character_,
                   Snap.Lat = NA_real_,
                   Snap.Long = NA_real_,
                   stringsAsFactors = FALSE)

  return(df)
}
