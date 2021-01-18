function(input, output, session) {
  
  # geo analysis -----
  source(file = "rscripts/geo_analysis_server.R", local = T)$value

  # time series analysis -----
  source(file = "rscripts/time_series_analysis_server.R", local = T)$value

  # seasonal analysis -----
  source(file = "rscripts/seasonal_analysis_server.R", local = T)$value
    
  # intro -----
  observeEvent(input$intro_button, {
    
    intro_tabset_func <- I(
      "
      if (this._currentStep == 1) { 
        $('a[data-value=\"Geo Analysis\"]').click();
      } else if (this._currentStep == 2) { 
        $('a[data-value=\"Time Series Analysis\"]').click();
      } else if (this._currentStep == 3) { 
        $('a[data-value=\"Seasonal Analysis\"]').click();
      }
      "
    )
    
    introjs(
      session = session, 
      options = list(
        nextLabel = "Next",
        prevLabel = "Previous",
        skipLabel = "Exit",
        doneLabel = "Done",
        hidePrev = T,
        hideNext = T,
        showStepNumbers = T,
        showButtons = T,
        showBullets = F,
        showProgress = F,
        disableInteraction = T 
      ),
      events = list(onchange = intro_tabset_func)
    )
  })

}
