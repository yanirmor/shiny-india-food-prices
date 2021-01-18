# data -----

seasonal_df <- reactive({
  df <- price_df %>% filter(commodity == input$commodity)  
  
  year_means <- df %>% 
    group_by(year) %>% 
    summarize(mean = mean(price)) %>% 
    as.data.frame()
  
  prices <- df %>% 
    group_by(year_month_index, year, season) %>% 
    summarize(price = mean(price)) %>% 
    as.data.frame()
  
 prices %>% 
    inner_join(year_means, by = "year") %>%
    mutate(normalized_price = price / mean)
})

# box plot -----

box_plot_params <- reactive({
  
  req(input$screen_width)
  
  if (input$screen_width > 576) {
    
    list(
      text_size = 18,
      x_axis_text_size = 16,
      y_axis_text_size = 14,
      x_labels_angle = 45
    )
    
  } else {
    
    list(
      text_size = 16,
      x_axis_text_size = 14,
      y_axis_text_size = 12,
      x_labels_angle = 45
    )
    
  }
  
})

output$box_plot <- renderPlot({
  seasonal_df() %>%
    
    ggplot(mapping = aes(x = season, y = normalized_price, fill = season)) +
    
    geom_boxplot(show.legend = F, size = 0.75, alpha = 1, width = 0.35) +
    
    scale_fill_manual(values = c("#5aa3bb", "#fcf854", "#2cb824", "#e3362d")) +
    
    labs(x = NULL, y = "Normalized Price") +
    
    theme(
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank(),
      text = element_text(size = box_plot_params()$text_size, family = "Open Sans"),
      axis.text.x = element_text(
        angle = box_plot_params()$x_labels_angle, 
        vjust = 0.65, 
        size = box_plot_params()$x_axis_text_size, 
        color = "#000000",
        margin = margin(t = 10)
      ),
      axis.text.y = element_text(size = box_plot_params()$y_axis_text_size),
      axis.ticks.x = element_blank(),
      axis.title.y = element_text(margin = margin(r = 10)),
      legend.position = "top",
      panel.background = element_rect(fill = "#f2f2f2")
    )
})

# tukey hsd -----

tukey_df <- reactive({
  anova_fit <- aov(formula = normalized_price ~ season, data = seasonal_df())
  
  TukeyHSD(anova_fit)$season %>%
    as.data.frame() %>%
    rownames_to_column(var = "Pair") %>%
    transmute(
      Pair,
      `P-Value` = round(`p adj`, 5),
      Significance = ifelse(
        test = `p adj` < 0.05, 
        yes = "<span class=\"green\">&#10004;</span>", 
        no = "<span class=\"red\">&#x2718;</span>"
      )
    ) %>%
    arrange(`P-Value`)
})

# tukey table -----

output$tukey_table <- renderTable(
  expr = tukey_df(),
  spacing = "m",
  align = "c",
  digits = 5,
  sanitize.text.function = identity
)
