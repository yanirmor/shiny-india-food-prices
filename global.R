# packages ----------------------------------------------------------------
library(shiny)
library(dplyr)
library(stringr)
library(ggplot2)
library(sp)
library(rgeos)
library(leaflet)
library(DBI)
library(RPostgres)

# scripts -----------------------------------------------------------------
source("R/functions.R")
source("R/modals.R")

# prices data -------------------------------------------------------------
# source: http://vam.wfp.org/sites/data/WFPVAM_FoodPrices_05-12-2017.csv
# prices_data <- data.table::fread("data/WFPVAM_FoodPrices_05-12-2017.csv")
# prices_data <- prices_data %>% filter(adm0_name == "India", mp_year >= 2010)
# saveRDS(object = prices_data, file = "data/prices_data.RDS")
df <- readRDS(file = "data/prices_data.RDS") %>% clean_prices_data()

# geo_data ----------------------------------------------------------------
# source: http://biogeo.ucdavis.edu/data/diva/adm/IND_adm.zip
# geo_data <- rgdal::readOGR(dsn = "data/IND_adm", layer = "IND_adm1")
# geo_data <- rmapshaper::ms_simplify(input = geo_data)
# saveRDS(object = geo_data, file = "data/geo_data.RDS")
sp_df <- readRDS(file = "data/geo_data.RDS") %>% clean_geo_data()

# options -----------------------------------------------------------------
options(scipen = 10)
