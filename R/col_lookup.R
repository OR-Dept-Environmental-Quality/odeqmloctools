#' Look up a column name
#'
#' Retrieve a column name in AWQMS based on the column name in the template (or vice versa)
#' @param col Column name
#' @param from Column source name. Either "template", "AWQMS", or "stations".
#' @param to Name of the column in the source you are looking up. Either "template", "AWQMS", or "stations".
#' @export
#'


col_lookup <-function(col, from, to) {

  template_to_AWQMS <- list("OrganizationID"="OrganizationID",
                            "org_name"="org_name",
                            "Monitoring.Location.ID"="MLocID",
                            "Monitoring.Location.Name"="StationDes",
                            "Monitoring.Location.Type"="MonLocType",
                            "EcoRegion3"="EcoRegion3",
                            "EcoRegion4"="EcoRegion4",
                            "HUC.8.Code"="HUC8",
                            "HUC8_Name"="HUC8_Name",
                            "HUC10"="HUC10",
                            "HUC12"="HUC12",
                            "HUC12_Name"="HUC12_Name",
                            "Latitude"="Lat_DD",
                            "Longitude"="Long_DD",
                            "Reachcode"="Reachcode",
                            "Measure"="Measure",
                            "AU_ID"="AU_ID",
                            "Equipment.ID"="Equipment_ID",
                            "Sample.Media"="Media",
                            "Sample.Sub.Media"="Sub_Media",
                            "Characteristic.Name"="Char_Name",
                            "Sample.Depth"="Depth",
                            "Sample.Depth.Unit"="Depth_Unit",
                            "Activity.Start.Date"="Result_Date",
                            "Activity.Start.Time"="Result_Time",
                            "Activity.Start.End.Time.Zone"="Time_Zone",
                            "Operator"="Operator",
                            "Result.Value"="Result_Numeric",
                            "Result.Unit"="Result_Unit",
                            "Result.Status.ID"="Result_Status",
                            "DQL"="DQL",
                            "Result.Comment"="Comments")

  AWQMS_to_template <- list("OrganizationID"="OrganizationID",
                            "org_name"="org_name",
                            "Project1"="Project.ID",
                            "Project2"=NA_character_,
                            "Project3"=NA_character_,
                            "MLocID"="Monitoring.Location.ID",
                            "StationDes"="Monitoring.Location.Name",
                            "MonLocType"="Monitoring.Location.Type",
                            "EcoRegion3"="EcoRegion3",
                            "EcoRegion4"="EcoRegion4",
                            "HUC8"="HUC.8.Code",
                            "HUC8_Name"="HUC8_Name",
                            "HUC10"="HUC10",
                            "HUC12"="HUC12",
                            "HUC12_Name"="HUC12_Name",
                            "Lat_DD"="Latitude",
                            "Long_DD"="Longitude",
                            "Reachcode"="Reachcode",
                            "Measure"="Measure",
                            "AU_ID"="AU_ID",
                            "Equipment_ID"="Equipment.ID",
                            "Media"="Sample.Media",
                            "Sub_Media"="Sample.Sub.Media",
                            "Char_Name"="Characteristic.Name",
                            "Depth"="Sample.Depth",
                            "Depth_Unit"="Sample.Depth.Unit",
                            "Result_Date"="Activity.Start.Date",
                            "Result_Time"="Activity.Start.Time",
                            "Time_Zone"="Activity.Start.End.Time.Zone",
                            "Operator"="Operator",
                            "Result_Numeric"="Result.Value",
                            "Result_Unit"="Result.Unit",
                            "Result_Status"="Result.Status.ID",
                            "DQL"="DQL",
                            "Comments"="Result.Comment")

  stations_to_template <- list("OrgID"="OrganizationID",
                               "station_key"=NA_character_,
                               "MLocID"="Monitoring.Location.ID",
                               "StationDes"="Monitoring.Location.Name",
                               "Lat_DD"="Latitude",
                               "Long_DD"="Longitude",
                               "Datum"="Horizontal.Datum",
                               "CollMethod"="Coordinate.Collection.Method",
                               "MapScale"="Source.Map.Scale",
                               "AU_ID"=NA_character_,
                               "MonLocType"="Monitoring.Location.Type",
                               "TribalLand"="Tribal.Land",
                               "TribalName"="Tribal.Land.Name",
                               "AltLocID"="Alternate.ID.1",
                               "AltLocName"="Alternate.Context.1",
                               "WellType"=NA_character_,
                               "WellFormType"=NA_character_,
                               "WellDepth"=NA_character_,
                               "WellDepthUnit"=NA_character_,
                               "Comments"="Monitoring.Location.Comments",
                               "IsFinal"=NA_character_,
                               "WellAquiferName"=NA_character_,
                               "STATE"="State.Code",
                               "COUNTY"="County.Name",
                               "T_R_S"=NA_character_,
                               "EcoRegion3"="EcoRegion3",
                               "EcoRegion4"="EcoRegion4",
                               "HUC4_Name"=NA_character_,
                               "HUC6_Name"=NA_character_,
                               "HUC8_Name"=NA_character_,
                               "HUC10_Name"=NA_character_,
                               "HUC12_Name"=NA_character_,
                               "HUC8"="HUC.8.Code",
                               "HUC10"=NA_character_,
                               "HUC12"=NA_character_,
                               "ELEV_Ft"=NA_character_,
                               "GNIS_Name"=NA_character_,
                               "Reachcode"="Reachcode",
                               "Measure"="Measure",
                               "LLID"="LLID",
                               "RiverMile"="River.Mile",
                               "SnapDate"=NA_character_,
                               "ReachRes"=NA_character_,
                               "Perm_ID_PT"=NA_character_,
                               "SnapDist_ft"=NA_character_,
                               "Conf_Score"=NA_character_,
                               "QC_Comm"=NA_character_,
                               "UseNHD_LL"=NA_character_,
                               "Permanent_Identifier"="Permanent.Identifier",
                               "COMID"=NA_character_,
                               "precip_mm"=NA_character_,
                               "temp_Cx10"=NA_character_,
                               "Predator_WorE"=NA_character_,
                               "Wade_Boat"=NA_character_,
                               "ReferenceSite"=NA_character_,
                               "FishCode"=NA_character_,
                               "SpawnCode"=NA_character_,
                               "WaterTypeCode"=NA_character_,
                               "WaterBodyCode"=NA_character_,
                               "BacteriaCode"=NA_character_,
                               "DO_code"=NA_character_,
                               "ben_use_code"=NA_character_,
                               "pH_code"=NA_character_,
                               "DO_SpawnCode"=NA_character_,
                               "OWRD_Basin"=NA_character_,
                               "TimeZone"="Activity.Start.End.Time.Zone",
                               "EcoRegion2"=NA_character_,
                               "UserName"=NA_character_,
                               "Created_Date"=NA_character_)



  if (from == "template" & to == "AWQMS") {

    to_val <- template_to_AWQMS[[col]]

  }

  if (from == "AWQMS" & to == "template") {

    to_val <- AWQMS_to_template[[col]]

  }

  if (from == "stations" & to == "template") {

    to_val <- stations_to_template[[col]]

  }


  return(to_val)

}
