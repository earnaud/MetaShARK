# fill.R

### IMPORTS ###

### UI ###
welcomeUI <- function(id, IM){
  ns <- NS(id)
  
  fluidPage(
    h1("under construction")
  )
  
}



### SERVER ###
welcome <- function(input, output, session, IM){
  ns <- session$ns
  output$wd <- renderText({paste("a:",getwd())})
}