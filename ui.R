fluidPage(
  # page setup --------------------------------------------------------------
  title = "India Food Prices",
  includeCSS("www/style.css"),
  includeScript("www/script.js"),

  # header ------------------------------------------------------------------
  fluidRow(column(12, div(
    id = "header", 
    h1("India Food Prices"), 
    fluidRow(
      img(src = "india.png", height = 30),
      img(src = "grain.png", height = 30)
    ),
    h5("Created by Yanir Mor © 2018")
  ))),
  
  fluidRow(
    # sidebar -----------------------------------------------------------------
    column(width = 3, wellPanel(
      id = "sidebar",
      
      h2("Welcome!"),
      fluidRow(column(width = 10, offset = 1, selectInput(
        inputId = "commodity",
        label = "Please select a commodity to analyze",
        width = "100%",
        choices = unique(df$commodity),
        selected = "Wheat"
      ))),
      
      br(), br(), br(), br(), 
      
      fluidRow(column(12, actionLink(
        inputId = "about",
        label = tagList(icon("question-circle"), "About")
      ))),
      hr(),
      fluidRow(column(12, actionLink(
        inputId = "contact", 
        label = tagList(icon("envelope"), "Contact / Hire Me")
      ))),
      hr(),
      fluidRow(column(12, a(
        icon("github"), "Get Code",
        href = "https://github.com/yanirmor/india-food-prices",
        target = "_blank"
      ))),
      hr(),
      fluidRow(column(12, actionLink(
        inputId = "licenses",
        label = tagList(icon("file-text"), "Licenses")
      )))
    )),

    # tabs --------------------------------------------------------------------
    column(width = 9, tabsetPanel(
      
      tabPanel(
        title = tagList(icon("globe"), "Geo Analysis"), 
        hr(),
        fluidRow(
          column(width = 9, leafletOutput("map_plot", height = 650)),
          column(
            width = 3, 
            align = "left", 
            HTML(paste(readLines("text/map_text.txt"), collapse = ""))
          ),
          br()
        )
      ),
      
      tabPanel(
        title = tagList(icon("line-chart"), "Time Series Analysis"), 
        hr(),
        fluidRow(
          column(width = 9, plotOutput("bars_line_plot")),
          column(
            width = 3, 
            align = "left", 
            HTML(paste(readLines("text/bars_line_text.txt"), collapse = ""))
          ),
          br()
        )
      ),
      
      tabPanel(
        title = tagList(icon("umbrella"), "Seasonal Analysis"), 
        hr(),
        fluidRow(
          column(
            width = 9, 
            plotOutput("box_plot", height = 350),
            h4(strong("Tukey's HSD test"), align = "left"),
            DT::dataTableOutput("tukey_table", height = 250)
          ),
          column(
            width = 3, 
            align = "left", 
            HTML(paste(readLines("text/boxplot_text.txt"), collapse = ""))
          ),
          br()
        )
      )
    ))
  )
)
