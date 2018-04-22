clean_prices_data <- function(df) {
  df <- df %>% 
    select(
      country = adm0_name,
      region = adm1_name,
      market = mkt_name,
      commodity = cm_name,
      currency = cur_name,
      measurement_unit = um_name,
      month = mp_month,
      year = mp_year,
      price = mp_price
    )

  df$year_month <- paste0(
    df$year, "-",
    str_pad(string = df$month, width = 2, pad = "0")
  )
  
  index <- data.frame(
    year_month_index = 1:length(unique(df$year_month)),
    year_month = sort(unique(df$year_month)),
    stringsAsFactors = F
  )
  
  df <- df %>% inner_join(index, by = "year_month")

  df$region <- df$region %>% str_extract("[A-z]+")
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
  
  df$season <- factor(
    df$season, 
    levels = c("Winter", "Summer", "Monsoon", "Autumn")
  )

  df
}

clean_geo_data <- function(sp_df) {
  sp_df$region <- as.character(sp_df$NAME_1)
  sp_df$region[sp_df$region == "Uttaranchal"] <- "Uttarakhand"

  centroids_coords <- gCentroid(sp_df, byid = T) %>% as.data.frame()
  sp_df$centroid_lng <- centroids_coords$x
  sp_df$centroid_lat <- centroids_coords$y

  sp_df
}

plot_map_base <- function(sp_df) {
  leaflet(data = sp_df) %>%
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
    setView(lat = 22.5, lng = 83, zoom = 5) %>%
    addPolygons(
      fill = F,
      color = "#000000",
      weight = 1,
      opacity = 0.25,
      smoothFactor = 1
    ) %>%
    addEasyButton(
      easyButton(
        icon = icon("home"),
        title= "Reset Zoom",
        onClick = JS(
          c("function(btn, map) {map.setView(new L.LatLng(22.5, 83), 5);}")
        )
      )
    ) %>%
    addControl(
      layerId = "years_control",
      html = sliderInput(
        inputId = "years", 
        label = NULL, 
        width = "200px",
        min = 2010, 
        max = 2017, 
        step = 1, 
        value = c(2010, 2017), 
        sep = "", 
        ticks = F
      ),
      position = "topright"
    )
}

scale_circles_radius <- function(x, min_value = 50000, max_value = 150000) {
  (max_value - min_value) * (x - min(x, na.rm = T)) /
    (max(x, na.rm = T) - min(x, na.rm = T)) + min_value
}

calculate_standard_scores <- function(df) {
  prices <- df %>% 
    group_by(year_month_index, commodity) %>% 
    summarize(price = mean(price))
  
  means_and_sds <- prices %>% 
    group_by(commodity) %>% 
    summarize(mean = mean(price), sd = sd(price))
  
  scores <- prices %>%
    inner_join(means_and_sds, by = "commodity") %>%
    mutate(score = (price - mean) / sd)
  
  monthly_scores <- scores %>% 
    group_by(year_month_index) %>% 
    summarize(score = mean(score))
  
  list(scores = scores, monthly_scores = monthly_scores)
}

plot_bars_line_base <- function(scores_df, x_labels) {
  ggplot(mapping = aes(x = year_month_index, y = score)) +
    geom_bar(
      data = scores_df,
      mapping = aes(fill = "placeholder"),
      alpha = 0.75,
      stat = "identity"
    ) +
    scale_x_continuous(
      breaks = seq(1, 96, 12),
      labels = x_labels
    ) +
    scale_fill_manual(
      breaks = "placeholder",
      values = "#C1CBD5",
      labels = NULL,
      name = "All Comodities",
      guide = guide_legend(keywidth = 7, keyheight = 1)
    ) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    annotate(
      geom = "text",
      x = 0,
      y = 0,
      label = "(Mean)",
      vjust= -0.25,
      size = 5
    ) +
    labs(x = "Year-Month", y = "Standard Score (Z)") +
    theme(
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      text = element_text(size = 18),
      axis.text.x = element_text(angle = 22.5, vjust = 0.65),
      legend.position = "top",
      panel.background = element_rect(fill = "#F0F0F0")
    )
}

plot_bars_line_dynamic <- function(scores_df, base, commodity_input) {
  base +
    geom_line(
      data = scores_df %>% filter(commodity == commodity_input),
      mapping = aes(color = "placeholder"),
      size = 1.5
    ) +
    scale_color_manual(
      breaks = "placeholder",
      values = "#2B2960",
      labels = NULL,
      name = commodity_input,
      guide = guide_legend(keywidth = 7, keyheight = 1)
    )
}

calculate_season_prices <- function(df, commodity_input) {
  df <- df %>% filter(commodity == commodity_input)
  
  year_means <- df %>% group_by(year) %>% summarize(mean = mean(price))
  
  prices <- df %>% 
    group_by(year_month_index, year, season) %>% 
    summarize(price = mean(price))
  
  prices %>% 
    inner_join(year_means, by = "year") %>%
    mutate(normalized_price = price / mean)
}

plot_boxplot <- function(season_prices) {
  season_prices %>%
    ggplot(mapping = aes(x = season, y = normalized_price, fill = season)) +
    geom_boxplot(show.legend = F, size = 0.75, alpha = 0.75) +
    scale_fill_manual(
      values = c("#3E88C9", "#C9AD3E", "#71C93E", "#C96C3E")
    ) +
    labs(x = NULL, y = "Normalized Price") +
    theme(
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      text = element_text(size = 18),
      axis.text.x = element_text(angle = 22.5, vjust = 0.65),
      legend.position = "top",
      panel.background = element_rect(fill = "#F0F0F0")
    )
}

compute_tukey_hsd <- function(season_prices) {
  anova_fit <- aov(normalized_price ~ season, season_prices)
  
  TukeyHSD(anova_fit)$season %>% 
    as.data.frame() %>%
    tibble::rownames_to_column(var = "Pair") %>%
    transmute(
      Pair, 
      `P-Value` = round(`p adj`, 5), 
      Significance = `p adj` < 0.05
    )
}

submit_contact_form <- function(name, email, subject, message, session) {
  if (any(nchar(c(name, message)) == 0)) {
    return(
      list(
        status = "Name and message are mandatory fields", 
        validation = F
      )
    )
  } 
  
  if (any(nchar(c(name, email)) > 50)) {
    return(
      list(
        status = "Max 50 characters for the name / email fields", 
        validation = F
      )
    )
  }    
  
  if (nchar(message) > 255) {
    return(
      list(
        status = "Max 255 characters for the message field", 
        validation = F
      )
    )
  }
  
  source("R/db_connection.R", local = T)
  statement <- readLines(con = "SQL/insert_into_contact_table.sql") %>% 
    paste(collapse = "")
  
  statement <- sqlInterpolate(
    conn = CONNECTION, 
    sql = statement,
    name = name, 
    email = email, 
    subject = subject, 
    message = message
  )
  
  result <- dbSendQuery(conn = CONNECTION, statement = statement)
  dbClearResult(res = result)
  dbDisconnect(conn = CONNECTION)
  
  updateTextInput(session, inputId = "name", value = "")
  updateTextInput(session, inputId = "email", value = "")
  updateSelectInput(session, inputId = "subject", selected = "general")
  updateTextAreaInput(session, inputId = "message", value = "")
  
  list(status = "Submitted successfully", validation = T)
}
