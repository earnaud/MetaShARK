# EMLAL.R

### IMPORTS ###
library(devtools)
library(EMLassemblyline)

source("modules/fill/EMLAL/EMLAL_functions.R")
source("modules/fill/EMLAL/EMLAL_selectDP.R")
source("modules/fill/EMLAL/EMLAL_createDP.R")

### RESOURCES ###
DP.path <- "dataPackagesOutput/emlAssemblyLine/"  ; dir.create(DP.path, recursive = TRUE, showWarnings = FALSE)

# Derived Id Modules from IM.EMLAL by pasting the step number (https://ediorg.github.io/EMLassemblyline/articles/overview.html)

### UI ###
EMLALUI <- function(id, IM){
  ns <- NS(id)
  
  steps = list(`Organize data package` = 1,
               `Create metadata templates` = 2,
               `Edit metadata templates` = 3,
               `Make EML` = 4)
  step = steps[[1]]
  
  fluidPage(
    style="padding-top:2.5%;",
    box(
      title = "Authorship",
      HTML(
        "<p>The `EML Assembly Line` package used in this module
        and its children is the intellectual property of the
        Environment Data Initiative (EDI). You can find further
        details on their 
        <a href=https://github.com/EDIorg/EMLassemblyline>git repository</a>.</p>"
      )
    ),
    box(
      title = "How to use",
      HTML(
        "<p>You can find a summary of the way the tool work on 
        <a href=https://ediorg.github.io/EMLassemblyline/articles/overview.html>this page</a>.</p>"
      )
    ),
    tabBox(
      title = "EML Assembly Line",
      id = ns("main"),
      side = "left", width = 12,
      tabPanel(
        value = "select-tab",
        title = icon("plus-circle"),
        uiOutput(ns("EMLALUI.select"))
      ),
      tabPanel(
        value = "create-tab",
        title = icon("arrow-alt-circle-right"),
        uiOutput(ns("EMLALUI.create"))
      )
    )
  )
}



### SERVER ###
EMLAL <- function(input, output, session, IM){
  ns <- session$ns
  
  # reactive values
  steps = paste0(c("select","create","edit","make","publish"), "-tab")
  
  # Output
  output$EMLALUI.select <- renderUI({ selectDPUI(id = IM.EMLAL[1],
                                                 IM = IM.EMLAL,
                                                 title = steps[1],
                                                 DP.path = DP.path)
                            })
  output$EMLALUI.create <- renderUI({ createDPUI(id = IM.EMLAL[1],
                                                 IM = IM.EMLAL,
                                                 title = steps[2],
                                                 testArgs = "testArgs")
                           })
                               
  
}




