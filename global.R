# environment -----
rm(list = ls())
invisible(gc())
options(encoding = "UTF-8", scipen = 999, stringsAsFactors = F, max.print = 80)
if (interactive()) options(shiny.autoreload = T)

# packages -----
suppressPackageStartupMessages({
  library(shiny)
  library(dplyr)
  library(tibble)
  library(scales)
  library(ggplot2)
  library(leaflet)
  library(RPostgres)
  library(DBI)
  library(extrafont)
  library(rintrojs)
})

# scripts -----
source(file = "functions.R")
source(file = "R/get_price_data.R")
source(file = "R/get_geo_data.R")

# static data -----
if (file.exists("data/price_df.RDS") == F) get_price_data()
if (file.exists("data/geo_sp_df.RDS") == F) get_geo_data()

price_df <- readRDS(file = "data/price_df.RDS")
geo_sp_df <- readRDS(file = "data/geo_sp_df.RDS")
