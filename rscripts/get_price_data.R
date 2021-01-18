get_price_data <- function() {
  suppressPackageStartupMessages({
    library(data.table)
    library(dplyr)
    library(stringr)
  })
  
  df <- fread(input = "http://vam.wfp.org/sites/data/WFPVAM_FoodPrices_05-12-2017.csv")
  
  df <- df %>% 
    filter(
      adm0_name == "India", 
      mp_year >= 2010
    ) %>%
    transmute(
      country = adm0_name,
      region = adm1_name,
      market = mkt_name,
      commodity = cm_name,
      measurement_unit = um_name,
      price = mp_price,
      currency = cur_name,
      year = mp_year,
      month = mp_month,
      year_month = paste(year, str_pad(string = month, width = 2, pad = "0"), sep = "-")
    )
  
  index <- data.frame(
    year_month_index = 1:length(unique(df$year_month)),
    year_month = sort(unique(df$year_month))
  )
  
  df <- df %>% inner_join(y = index, by = "year_month")
  
  df$region <- df$region %>% str_extract(pattern = "[A-z]+")
  df$region[df$region == "Andaman"] <- "Andaman and Nicobar"
  df$region[df$region == "Himachal"] <- "Himachal Pradesh"
  df$region[df$region == "Andhra"] <- "Andhra Pradesh"
  df$region[df$region == "Tamil"] <- "Tamil Nadu"
  df$region[df$region == "Madhya"] <- "Madhya Pradesh"
  df$region[df$region == "Arunachal"] <- "Arunachal Pradesh"
  df$region[df$region == "West"] <- "West Bengal"
  df$region[df$region == "Uttar"] <- "Uttar Pradesh"
  df$region[df$market %in% c("Jammu", "Srinagar")] <- "Jammu and Kashmir"
  
  df$season[df$month %in% 1:3] <- "Winter"
  df$season[df$month %in% 4:6] <- "Summer"
  df$season[df$month %in% 7:9] <- "Monsoon"
  df$season[df$month %in% 10:12] <- "Autumn"
  
  df$season <- df$season %>% 
    factor(levels = c("Winter", "Summer", "Monsoon", "Autumn"))
  
  saveRDS(object = df, file = "data/price_df.RDS")
}
