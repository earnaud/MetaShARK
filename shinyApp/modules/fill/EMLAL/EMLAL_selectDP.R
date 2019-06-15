# EMLAL_functions.R

### IMPORTS ###
library(shinyFiles)

### UI OUTPUTS ###

## 0. SELECT DATA PACKAGE
selectDPUI <- function(id, title, width=12, DP.path, IM){
  ns <- NS(id)
  
  # tmp
  if(length(list.files(DP.path))==0)
    DP.list <- "Sorry, yet no data package has been saved in this location"
  else
    DP.list <- list.files(DP.path)

  return(
    box(title = paste("EML Assembly Line -" ,title),
        width = width,
        fluidPage(
          fluidRow(
            column(ceiling(width/2),
                   h4("Edit existing data package",
                      style="text-align:center"),
                   DP.list),
            column(floor(width/2),
                   h4("Create new data package",
                      style="text-align:center"),
                   textInput(ns("dp.name"),
                             "Enter a data package name:",
                             placeholder=paste0("eml.datapackage.",
                                                Sys.Date())),
                   shinyDirButton(ns("dp.dir.browse"),"Browse ...", "Please select a location to save your data package", FALSE),
                   HTML("</br>"),
                   actionButton(ns("nextStep"),"Next")
            ) # end column2
          ) # end fluidRow
        ) # end fluidPage
      ) # end box
    ) # end return
}

selectDP <- function(input, output, session, IM, DP.path){
  ns <- session$ns
  
  shinyDirChoose(input = input, id = ns("dp.dir.browse"))
  
  observe({
    if(is.null(input$dp.name) 
       || length(input$name) == 0 
       || input$name == "")
      shinyjs::hide("nextStep")
    else
      shinyjs::show("nextStep")
  })
 
  
}

#---- 
# other functions
chooseDirectory = function(caption = 'Select data directory') {
  if (exists('utils::choose.dir')) {
    choose.dir(caption = caption) 
  } else {
    tk_choose.dir(caption = caption)
  }
}