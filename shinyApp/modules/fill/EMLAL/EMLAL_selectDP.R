# EMLAL_functions.R

### IMPORTS ###
library("tcltk2")

### UI OUTPUTS ###

## 0. SELECT DATA PACKAGE
selectDPUI <- function(id, title, width=12, IM, DP.path){
  ns <- NS(id)
  
  # tmp
  if(length(list.files(DP.path))==0)
    DP.list <- "Sorry, yet no data package has been saved in this location"
  else
    DP.list <- list.files(DP.path)

  return(
      fluidPage(
        title = "1. Organize data packages",
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
                actionButton(ns("dp.dir.browse"), "Browse ..."),
                div(id = ns("dp.dir.choose"),
                  tags$b("Currently selected folder:"),
                  br(),
                  textOutput(ns("dp.dir.choose")), 
                  style = "white-space: nowrap;
                          text-overflow: ellipsis;
                          overflow: hidden;"
                ),
                HTML("</br>"),
                actionButton(ns("create-button"),"Create"),
                div(id=ns("create-warning-duplicated"),
                    style="color:red;",
                    span("WARNING: such a data package already exists (same name, same location).",br(),
                         "Clicking 'Create' will replace all its content."))
          ) # end column2
        ) # end fluidRow
      ) # end fluidPage
    ) # end return
}

selectDP <- function(input, output, session, IM, DP.path){
  ns <- session$ns
  
  # select DP directory
  output$dp.dir.choose <- tmp.dir.choose <- renderText({DP.path})
  
  observeEvent(input$dp.dir.browse, {
    tmp.dir.choose <-renderText({
      chooseDirectory(default = DP.path)
    })
    output$dp.dir.choose <- tmp.dir.choose
  })
  
  # reveal create-button
  observeEvent(input$dp.name, {
    DP.location <- tmp.dir.choose()
    DP.name <- input$dp.name
    
    if(is.null(DP.name)
       || !grepl("^[a-zA-Z0-9_\\-\\.]+$", DP.name) ){
      shinyjs::hide("create-button")
      shinyjs::hide("create-warning-duplicated")
      hideTab("main", "create-tab")
    } else {
      shinyjs::show("create-button")
      if(dir.exists(paste0(DP.location,DP.name))
         && nzchar(DP.name))
        shinyjs::show("create-warning-duplicated")
    }
  })
 
  # on click on create-button
  observeEvent(input[["create-button"]], {
    createDPFolder(DP.location = tmp.dir.choose(),
                   DP.name = input$dp.name)
    showTab("main", "create-tab", select = TRUE)
  })
  
  
}