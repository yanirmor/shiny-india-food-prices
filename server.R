function(input, output, session) {
  # sidebar modals ----------------------------------------------------------
  observeEvent(input$contact, {
    output$status <- renderUI(NULL)
    showModal(contact_modal)
  })
  
  observeEvent(input$submit, {
    result <- submit_contact_form(
      name = input$name,
      email = input$email, 
      subject = input$subject, 
      message = input$message, 
      session = session
    )
    
    output_color <- ifelse(result$validation, "#5FBF00", "#CD5C33")
    output$status <- renderUI({
      span(
        result$status, 
        style = paste0("font-size: 14; color: ", output_color, ";")
      )
    })
  })
  
  observeEvent(input$about, showModal(about_modal))
  
  observeEvent(input$licenses, showModal(licenses_modal))
  
  # map plot ----------------------------------------------------------------
  output$map_plot <- renderLeaflet(plot_map_base(sp_df = sp_df))
  
  reactive_sp_df <- reactive({
    req(input$years)
    
    grouped_df <- df %>%
      filter(
        between(year, input$years[1], input$years[2]),
        commodity == input$commodity
      ) %>%
      group_by(region, measurement_unit) %>%
      summarize(
        mean_price = round(mean(price), 1),
        max_price = round(max(price), 1),
        min_price = round(min(price), 1)
      )
    
    result <- sp_df
    result@data <- left_join(result@data, grouped_df, by = "region")
    result
  })
   
  observe({
    if (all(is.na(reactive_sp_df()$mean_price))) {
      return(
        leafletProxy(mapId = "map_plot") %>%
          removeShape(layerId = as.character(1:36)) %>%
          removeControl(layerId = "map_legend")
      )
    }
    
    colors_palette <- colorNumeric(
      palette = c("#5FBF00", "#CD5C33"),
      domain = reactive_sp_df()$mean_price
    )
    
    leafletProxy(mapId = "map_plot", data = reactive_sp_df()) %>%
      removeShape(layerId = as.character(1:36)) %>%
      removeControl(layerId = "map_legend") %>%
      addCircles(
        layerId = as.character(1:36),
        lng = ~centroid_lng,
        lat = ~centroid_lat,
        radius = ~scale_circles_radius(mean_price),
        stroke = F,
        fillOpacity = 0.85,
        fillColor = ~colors_palette(mean_price),
        popup = ~paste0(
          "<h4> <b>", region, "</b> </h4>", "<hr>",
          "<u> Prices (INR) per ", measurement_unit, "</u> <br>",
          "Average: ", mean_price, "<br>",
          "Max: ", max_price, "<br>",
          "Min: ", min_price
        )
      ) %>%
      addLegend(
        layerId = "map_legend",
        position = "bottomright",
        pal = colors_palette,
        values = ~mean_price[!is.na(mean_price)],
        title = ~paste(
          "Price per", 
          unique(measurement_unit[!is.na(measurement_unit)])
        ),
        labFormat = labelFormat(prefix = "₹"),
        opacity = 1
      )
  })
  
  # bars line plot ----------------------------------------------------------
  standard_scores <- calculate_standard_scores(df = df)
  
  bars_line_base <- plot_bars_line_base(
    scores_df = standard_scores$monthly_scores,
    x_labels = sort(unique(df$year_month))[seq(1, 96, 12)]
  )

  output$bars_line_plot <- renderPlot({
    plot_bars_line_dynamic(
      scores_df = standard_scores$scores,
      base = bars_line_base,
      commodity_input = input$commodity
    )
  })
  
  # box plot ----------------------------------------------------------------
  season_prices <- reactive({
    calculate_season_prices(df = df, commodity_input = input$commodity)
  })
  
  output$box_plot <- renderPlot(plot_boxplot(season_prices = season_prices()))
  
  output$tukey_table <- DT::renderDataTable(
    options = list(
      dom = "t", 
      order = list(list(1, "asc")), 
      columnDefs = list(list(className = 'dt-center', targets = 0:2))
    ),
    selection = "none",
    rownames = F,
    expr = compute_tukey_hsd(season_prices = season_prices())
  )
}
