# static data -----

time_series_df <- {
  prices <- price_df %>% 
    group_by(year_month_index, commodity) %>% 
    summarize(price = mean(price)) %>%
    as.data.frame()
  
  means_and_sds <- prices %>% 
    group_by(commodity) %>% 
    summarize(mean = mean(price), sd = sd(price)) %>%
    as.data.frame()
  
  scores <- prices %>%
    inner_join(y = means_and_sds, by = "commodity") %>%
    mutate(score = (price - mean) / sd)
  
  monthly_scores <- scores %>% 
    group_by(year_month_index) %>% 
    summarize(score = mean(score)) %>%
    as.data.frame()
  
  list(scores = scores, monthly_scores = monthly_scores)  
}

# base plot -----

base_bars_plot <- ggplot(mapping = aes(x = year_month_index, y = score)) +
  
  geom_bar(
    data = time_series_df$monthly_scores,
    mapping = aes(fill = "placeholder"),
    alpha = 0.75,
    stat = "identity",
    width = 1
  ) +
  
  geom_hline(yintercept = 0, linetype = "dashed") +
  
  labs(x = "Year-Month", y = "Standard Score (Z)") +
  
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    text = element_text(size = 18, family = "Open Sans"),
    axis.text.x = element_text(vjust = 0.65),
    axis.title.y = element_text(margin = margin(r = 10)),
    axis.title.x = element_text(margin = margin(t = 10)),
    legend.position = "top",
    panel.background = element_rect(fill = "#f2f2f2")
  )

# bars plot ------

bars_plot_params <- reactive({
  req(input$screen_width)
  
  if (input$screen_width > 993) {
    
    list(
      plot_width = 562,
      plot_height = 400,
      x_trans = "identity",
      x_axis_text_angle = 45,
      coord_flip = F,
      axis_title_size = NULL,
      axis_text_size = NULL,
      legend_keywidth = 7,
      legend_keyheight = 1,
      legend_text_size = 18,
      legend_direction = "horizontal",
      annotation_text_size = 5,
      annotation_text_hjust = 0.5
    )
    
  } else if (input$screen_width > 576) {
    
    list(
      plot_width = 500,
      plot_height = 355,
      x_trans = "identity",
      x_axis_text_angle = 45,
      coord_flip = F,
      axis_title_size = NULL,
      axis_text_size = NULL,
      legend_keywidth = 6,
      legend_keyheight = 1,
      legend_text_size = 16,
      legend_direction = "horizontal",
      annotation_text_size = 5,
      annotation_text_hjust = 0.25
    )
    
  } else {
    
    list(
      plot_width = 270,
      plot_height = 380,
      x_trans = "reverse",
      x_axis_text_angle = 0,
      coord_flip = T,
      axis_title_size = 14,
      axis_text_size = 10,
      legend_keywidth = 4,
      legend_keyheight = 0.75,
      legend_text_size = 14,
      legend_direction = "vertical",
      annotation_text_size = 3.5,
      annotation_text_hjust = -0.1
    )
    
  }
  
})

output$bars_plot <- renderPlot(
  width = function() bars_plot_params()$plot_width,
  height = function() bars_plot_params()$plot_height,
  
  expr = {
    
    base_bars_plot +
      
      scale_x_continuous(
        trans = bars_plot_params()$x_trans,
        breaks = seq(1, 96, 12),
        labels = sort(unique(price_df$year_month))[seq(1, 96, 12)]
      ) +
      
      annotate(
        geom = "text",
        x = 0,
        y = 0.025,
        label = "(Mean)",
        vjust= -0.25,
        hjust = bars_plot_params()$annotation_text_hjust,
        size = bars_plot_params()$annotation_text_size,
        family = "Open Sans"
      ) +
      
      geom_line(
        data = time_series_df$scores %>% filter(commodity == input$commodity),
        mapping = aes(color = "placeholder"),
        size = 1.5
      ) +
      
      scale_fill_manual(
        breaks = "placeholder",
        values = "#5aa3bb",
        labels = NULL,
        name = "All Comodities",
        guide = guide_legend(
          keywidth = bars_plot_params()$legend_keywidth, 
          keyheight = bars_plot_params()$legend_keyheight, 
          title.vjust = 1.5
        )
      ) +
      
      scale_color_manual(
        breaks = "placeholder",
        values = "#25414b",
        labels = NULL,
        name = input$commodity,
        guide = guide_legend(
          keywidth = bars_plot_params()$legend_keywidth, 
          keyheight = bars_plot_params()$legend_keyheight, 
          title.vjust = 1.5
        )
      ) +
      
      theme(
        legend.title = element_text(size = bars_plot_params()$legend_text_size),
        legend.direction = bars_plot_params()$legend_direction,
        axis.text.x = element_text(angle = bars_plot_params()$x_axis_text_angle),
        axis.title = element_text(size = bars_plot_params()$axis_title_size),
        axis.text = element_text(size = bars_plot_params()$axis_text_size)
      ) +
      
      if (bars_plot_params()$coord_flip) coord_flip() else list()
  }
)
