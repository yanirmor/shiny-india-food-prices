basicPage(
  # page set up -----
  tags$head(
    tags$meta(charset = "UTF-8"),
    
    tags$meta(
      name = "keywords",
      content = "R Shiny, Shiny, India Food Prices, Food Prices Analysis, World Food Programme, Yanir Mor"
    ),
    
    tags$meta(
      name = "description",
      content = "Statistical & geo-spatial analysis and visualization of food prices in India, using base R, ggplot2 and leaflet. The data was collected by the World Food Programme."
    ),
    
    tags$link(href = "icons/food.png", rel = "icon"),
    tags$link(href = "icons/food.png", rel = "apple-touch-icon"),
    tags$link(
      rel = "stylesheet", 
      href = "https://fonts.googleapis.com/css?family=Open+Sans"
    ),
    tags$title("India Food Prices"),
    
    includeScript(path = "js/matomo_script.js")
  ),
  
  includeCSS(path = "style.css"),
  includeCSS(path = "media_style.css"),
  includeScript(path = "script.js"),
  
  introjsUI(),
  includeCSS(path = "css/style_introjs.css"),
  includeCSS(path = "css/media_style_introjs.css"),
  
  # header -----
  tags$header(
    div(
      id = "header_title", 
      
      img(src = "icons/food.png"), 
      "India", span("Food", class = "third-color"), "Prices"
    ),
    
    div(
      id = "header_buttons",
      
      a(
        href = "https://www.yanirmor.com", 
        target = "_blank", 
        img(src = "icons/website.png"),
        title = "My Website"
      ),
      
      actionLink(
        inputId = "contact_button", 
        label = img(src = "icons/email.png"),
        title = "Contact"
      ),
      
      a(
        href = "https://github.com/yanirmor/shiny-india-food-prices", 
        target = "_blank", 
        img(src = "icons/github.png"),
        title = "Source Code"
      )
    )
  ),
  
  # body -----
  div(
    class = "wrapper",
    
    # filters -----
    introBox(
      data.step = 1,
      data.intro = paste(
        "This app demonstrates statistical and geo-spatial analysis of food prices in India, in R.<br><br>",
        "It is based on data collected by the World Food Programme.",
        "The results of the analysis are visualized using leaflet and ggplot2."
      ),
      
      id = "filters",
      
      actionButton(inputId = "intro_button", label = "?"),
      
      selectInput(
        inputId = "commodity",
        label = NULL,
        choices = sort(unique(price_df$commodity)),
        selected = "Wheat"
      ),
      
      # hr separator -----
      div(
        class = "hr-separator",
        div(class = "hr-line"),
        img(src = "icons/food.png"),
        div(class = "hr-line")
      )
    ),
    
    # tabset -----
    tabsetPanel(
      id = "tabset",
      
      tabPanel(
        title = "Geo Analysis",
        
        introBox(
          data.step = 2,
          data.intro = paste(
            "Comparison of food prices between states in India.<br><br>",
            "The color and the size of a circle represent the price of the selected commodity.",
            "Blocs of states within different geographical areas tend to have somewhat correlated prices."
          ),
          
          sliderInput(
            inputId = "years", 
            label = NULL, 
            min = 2010, 
            max = 2017, 
            step = 1, 
            value = c(2010, 2017), 
            sep = "",
            ticks = F
          ),
          
          leafletOutput(outputId = "map_plot")
        )
      ),
      
      tabPanel(
        title = "Time Series Analysis",
        
        introBox(
          data.step = 3,
          data.intro = paste(
            "Price trends visualized as standard scores (Z) over time.<br><br>",
            "The distance between a tip of a bar and a point in a line can tell how faster (or slower)",
            "the price of the selected commodity changes relative to the prices of all commodities."
          ),
          
          plotOutput(outputId = "bars_plot")
        )
      ),
      
      tabPanel(
        title = "Seasonal Analysis",
        
        introBox(
          data.step = 4,
          data.intro = paste(
            "Statistical analysis of seasonal trends.",
            "Seasons were mapped to Winter (Jan-Mar), Summer (Apr-Jun), Monsoon (Jul-Sep) and Autumn (Oct-Dec).<br><br>",
            "ANOVA and Tukey's HSD tests are used to determine if the differences are significant (P-value < 0.05)."
          ),
          
          plotOutput(outputId = "box_plot"),
          tableOutput(outputId = "tukey_table")
        )
      )
    )
  ),
  
  # footer -----
  tags$footer(
    div(
      id = "footer_copyright",
      "2019", 
      span(class = "third-color", "Yanir Mor"), 
      HTML("&copy;"), 
      "All Rights Reserved",
      span(
        id = "licenses",
        span(class = "third-color", "(Licenses)"),
        div(
          tags$li("Prices data by the WFP and HDX (CC BY 3.0 IGO)"),
          tags$li("Geo data by the DIVA-GIS project"),
          tags$li("Icon by PINPOINT.WORLD / Iconfinder")
        )
      )
    ),
    
    div(
      id = "privacy_notice",
      span("This website uses cookies to improve your experience"),
      actionButton(inputId = "privacy_notice_agree", label = "OK")
    )
  )
)
