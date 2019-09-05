# EMLAL_create.R

## 2. CREATE DATA PACKAGE
createDPUI <- function(id, title, IM){
  ns <- NS(id)
  
  return(
      fluidPage(
        textOutput("dp_name"),
        textOutput("dp_location")
      ) # end fluidPage
    ) # end return
}

createDP <- function(input, output, session, IM, previous){
  ns <- session$ns
  
  output$dp_name <- renderText({
    previous$dp_name
  })
  
  output$dp_location <- renderText({
    previous$dp_location
  })
}
