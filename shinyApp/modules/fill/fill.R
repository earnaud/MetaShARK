# fill.R

### IMPORTS ###
source("modules/fill/fill_functions.R")
source("modules/fill/welcome/fillWelcome.R")

cat("* Loading Fill Guidelines: \n")
fillGuideline = as.list(readRDS("resources/fillGuideline.RData"))
cat("** Fill Guideline successfully loaded !\n")

IM.welcome <- c("fillWelcomeModule", "fillWelcome")

### UI ###
fillUI <- function(id, IM){
  ns <- NS(id)
  
  fluidPage(
    uiOutput(ns("display"))
  )
  
}



### SERVER ###
fill <- function(input, output, session, IM, display = "welcome"){
  ns <- session$ns
  
  # reactiveValues
  values <- reactiveValues(display = display)
  
  ## Output
  # Reactives
  output$display <- renderUI({
    switch(values$display,
           "welcome" <- fillWelcomeUI(IM.welcome[1], IM.welcome))
  })
  
  # Modules
  # fillWelcome <- callModule(fillWelcome, IM.welcome[1], IM = IM.welcome)
  
}