get_price_data <- function() {
  suppressPackageStartupMessages({
    library(rgdal)
    library(rmapshaper)
    library(rgeos)
  })
  
  temp_dir <- tempdir()
  
  download.file(
    url = "http://biogeo.ucdavis.edu/data/diva/adm/IND_adm.zip",
    destfile = file.path(temp_dir, "IND_adm.zip")
  )
  
  unzip(
    zipfile = file.path(temp_dir, "IND_adm.zip"), 
    exdir = file.path(temp_dir, "IND_adm")
  )
  
  sp_df <- readOGR(
    dsn = file.path(temp_dir, "IND_adm"), 
    layer = "IND_adm1", 
    stringsAsFactors = F
  )
  
  sp_df <- ms_simplify(input = sp_df)
  
  sp_df$region <- sp_df$NAME_1
  sp_df$region[sp_df$region == "Uttaranchal"] <- "Uttarakhand"
  
  centroids_coords <- as.data.frame(x = gCentroid(spgeom = sp_df, byid = T))
  
  sp_df$centroid_lng <- centroids_coords$x
  sp_df$centroid_lat <- centroids_coords$y
  
  saveRDS(object = sp_df, file = "data/geo_sp_df.RDS")
}
