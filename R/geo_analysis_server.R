# map data -----

map_sp_df <- reactive({
  df <- price_df %>%
    filter(
      between(x = year, left = input$years[1], right = input$years[2]),
      commodity == input$commodity
    ) %>%
    group_by(region, measurement_unit) %>%
    summarize(
      mean_price = mean(price) %>% round(digits = 1),
      max_price = max(price) %>% round(digits = 1),
      min_price = min(price) %>% round(digits = 1)
    ) %>%
    as.data.frame()
  
  sp_df <- geo_sp_df
  
  sp_df@data <- left_join(x = sp_df@data, y = df, by = "region")
  
  sp_df
})

# base map -----

output$map_plot <- renderLeaflet({
    
  leaflet(data = geo_sp_df) %>%
    
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
    
    setView(lat = 22.5, lng = 82, zoom = 4) %>%
    
    addEasyButton(
      easyButton(
        icon = icon(name = "home"),
        title = "Reset Zoom",
        onClick = JS(
          "function(btn, map) { map.setView(new L.LatLng(22.5, 82), 4); }"
        )
      )
    ) %>%
    
    addPolygons(
      fill = F,
      color = "#000000",
      weight = 1,
      opacity = 0.25,
      smoothFactor = 1
    )
    
})

# map layers -----

observe({

  if (map_sp_df()$mean_price %>% is.na() %>% all()) {
    return(
      leafletProxy(mapId = "map_plot") %>%
        removeShape(layerId = as.character(1:36)) %>%
        removeControl(layerId = "map_legend")
    )
  }

  colors_palette <- colorNumeric(
    palette = c("#2cb824", "#e3362d"),
    domain = map_sp_df()$mean_price
  )

  leafletProxy(mapId = "map_plot", data = map_sp_df()) %>%

    addCircles(
      layerId = as.character(1:36),
      lng = ~ centroid_lng,
      lat = ~ centroid_lat,
      radius = ~ rescale(x = mean_price, to = c(50000, 150000)),
      stroke = F,
      fillOpacity = 0.85,
      fillColor = ~ colors_palette(mean_price),
      popup = ~paste0(
        "<div class=\"leaflet-popup-title\">", region, "</div>",
        "<div class=\"leaflet-popup-sub-title\">Prices per ", measurement_unit, "</div>",
        "<span>Average: &#x20B9;", mean_price, "</span><br>",
        "<span>Max: &#x20B9;", max_price, "</span><br>",
        "<span>Min: &#x20B9;", min_price, "</span>"
      )
    ) %>%

    addLegend(
      layerId = "map_legend",
      position = "bottomright",
      pal = colors_palette,
      values = ~ mean_price[!is.na(mean_price)],
      opacity = 1,
      title = ~ paste(
        HTML("&#x20B9;"),
        " / ",
        unique(measurement_unit[!is.na(measurement_unit)])
      )
    )
})
