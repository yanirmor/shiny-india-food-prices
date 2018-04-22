contact_modal <- modalDialog(
  title = h3("Contact / Hire Me"), 
  footer = NULL, 
  size = "s", 
  easyClose = T,
  textInput(
    inputId = "name", 
    label = HTML(paste0("Name", span("*", style = "color: red;"))),
    value = NULL,
    width = "100%"
  ),
  textInput(
    inputId = "email", 
    label = "Email", 
    value = NULL,
    width = "100%"
  ),
  selectInput(
    inputId = "subject",
    label = HTML(paste0("Subject", span("*", style = "color: red;"))),
    choices = c(
      "General" = "general",
      "Hire" = "hire",
      "Feedback" = "feedback",
      "Other" = "other"
    ),
    width = "100%"
  ),
  textAreaInput(
    inputId = "message", 
      label = HTML(paste0("Message", span("*", style = "color: red;"))),
    value = NULL,
    rows = 5,
    resize = "none"
  ),
  actionButton(inputId = "submit", label = "Submit"),
  br(), br(),
  htmlOutput("status")
)

about_modal <- modalDialog(
  id = "about_modal_dialog",
  title = h3("About"),
  footer = NULL,
  size = "m",
  easyClose = T,
  HTML(paste(readLines("text/about_text.txt"), collapse = ""))
)

licenses_modal <- modalDialog(
  id = "licenses_modal_dialog",
  title = h3("Licenses"),
  footer = NULL,
  size = "m",
  easyClose = T,
  HTML(paste(readLines("text/licenses_text.txt"), collapse = ""))
)
