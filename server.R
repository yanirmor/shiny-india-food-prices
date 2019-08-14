function(input, output, session) {

  # geo analysis -----
  source(file = "R/geo_analysis_server.R", local = T)$value

  # time series analysis -----
  source(file = "R/time_series_analysis_server.R", local = T)$value
  
  # seasonal analysis -----
  source(file = "R/seasonal_analysis_server.R", local = T)$value
    
  # intro -----
  observeEvent(input$intro_button, {
    
    session$sendCustomMessage(
      type = "matomoEvent", 
      message = c("IntroJS", "Click", "Click")
    )
    
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
  
  # contact form -----
  source(file = "R/contact_form_server.R", local = T)$value
  
  # privacy notice -----
  observeEvent(input$privacy_notice_agree, {
    session$sendCustomMessage(type = "privacyNoticeOk", message = "placeholder")
  })
}
