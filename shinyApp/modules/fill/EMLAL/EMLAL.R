# EMLAL.R

### IMPORTS ###
library(devtools)
library(EMLassemblyline)

### UI ###
EMLALUI <- function(id, IM){
  ns <- NS(id)
  
  steps = list(`Organize data package` = 1,
               `Create metadata templates` = 2,
               `Edit metadata templates` = 3,
               `Make EML` = 4)
  step = steps[[1]]
  
  fluidPage(
    div(
      h2("Authorship"),
      HTML(
        "<p>The `EML Assembly Line` package used in this module
        and its children is the intellectual property of the
        Environment Data Initiative (EDI). You can find further
        details on their 
        <a href=https://github.com/EDIorg/EMLassemblyline>git repository</a>.</p>"
      )
    ),
    div(
      h2("How to use"),
      HTML(
        "<p>You can find a summary of the way the tool work on 
        <a href=https://ediorg.github.io/EMLassemblyline/articles/overview.html>this page</a>.</p>"
      )
    ),
    # Variable output
    uiOutput("step")
  )
}



### SERVER ###
EMLAL <- function(input, output, session, IM){
  ns <- session$ns
  
  output$step <- renderUI(div("ok"))
}




