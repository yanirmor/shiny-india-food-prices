generic_modal <- function(error = T, content) {
  title <- if (error) {
    span(img(src = "icons/food_red.png", "Oops..."))
  } else {
    span(img(src = "icons/food_green.png", "Success!"))
  }
  
  showModal(
    modalDialog(
      title = title,
      easyClose = T,
      content
    )
  )
}

connect_to_db <- function() {
  dbConnect(
    drv = Postgres(), 
    host = Sys.getenv(x = "DB_HOST"),
    port = Sys.getenv(x = "DB_PORT"),
    dbname = Sys.getenv(x = "DB_NAME"),
    user = Sys.getenv(x = "DB_USER"),
    password = Sys.getenv(x = "DB_PASSWORD")
  )
}
