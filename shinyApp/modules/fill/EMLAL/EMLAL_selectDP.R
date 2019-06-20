# EMLAL_functions.R

### IMPORTS ###
library("tcltk2")

### UI ###
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
                # DP name
                textInput(ns("dp.name"),
                          "Enter a data package name:",
                          placeholder=paste0("eml.datapackage.",
                                            Sys.Date())),
                # DP location
                actionButton(ns("dp.dir.browse"), "Browse ..."),
                div(id = ns("dp.dir.choose"),
                    tags$b("Currently selected folder:"),
                    br(),
                    textOutput(ns("dp.dir.choose")), 
                    style = "white-space: nowrap;
                            text-overflow: ellipsis;
                            overflow: hidden;"
                ),
                # Data files
                
                fileInput(ns("data.files.browse"), 
                          "Select your data files (make sure they are in the same directory)",
                          multiple = TRUE),
                div(id = ns("data.files.choose"),
                    tags$b("Currently selected data files:"),
                    br(),
                    textOutput(ns("data.files.choose")), 
                    style = "white-space: nowrap;
                             text-overflow: ellipsis;
                             overflow: hidden;"
                ),
                # License choice
                HTML("</br>"),
                # DP creation
                conditionalPanel(
                  condition = "input.dp.name != '' || !/^[a-zA-Z0-9_-.]+$/.exec(input.dp.name) || !input.data.files.choose",
                  actionButton(ns("create-button"),"Create")
                ),
                # Warnings
                conditionalPanel(
                  condition = "output.warnings.duplicata",
                  div(style="color:red;",
                      span("WARNING: such a data package already exists (same name, same location).",br(),
                           "Clicking 'Create' will replace all its content. (located in: ",
                           textOutput(ns("dp.dir.choose"), inline = TRUE), textOutput(ns("dp.name"), inline = TRUE),")")
                  )
                )
          ) # end column2
        ) # end fluidRow
      ) # end fluidPage
    ) # end return
}

selectDP <- function(input, output, session, IM, DP.path){
  ns <- session$ns
  outvar = list()
  
  # select DP name
  output$dp.name <- renderText({ input$dp.name })
  
  # select DP directory
  output$dp.dir.choose <- outvar$dp.dir.choose <- renderText({ DP.path })
  
  observeEvent(input$dp.dir.browse, {
    outvar$dp.dir.choose <-renderText({
      chooseDirectory()
    })
    if(is.na(outvar$dp.dir.choose)) outvar$dp.dir.choose <- renderText({DP.path})
    output$dp.dir.choose <- outvar$dp.dir.choose
  })
  
  # select Data files
  output$data.files.choose <- outvar$data.files.choose <- renderText({ NULL })
  
  observeEvent(input$data.files.browse, {
    outvar$data.files.choose <- renderText({
      chooseDirectory()
    })
    if(is.na(outvar$data.files.choose)) outvar$data.files.choose <- renderText({ NULL })
    output$data.files.choose <- outvar$data.files.choose
  })
  
  # reveal buttons
  output$warnings.duplicata <- renderText({
    as.character(dir.exists(paste0(outvar$dp.dir.choose(), input$dp.name)) && nzchar(input$dp.name))
  })
  outputOptions(output, "warnings.duplicata", suspendWhenHidden = FALSE)
  
  
  
  # observeEvent(input$dp.name, {
  #   DP.location <- outvar$dp.dir.choose()
  #   DP.name <- input$dp.name
  #   data.location <- outvar$data.files.choose()
  #   
  #   if(is.null(DP.name)
  #      || !grepl("^[a-zA-Z0-9_\\-\\.]+$", DP.name)
  #      || is.null( outvar$data.files.choose() )){
  #     shinyjs::hide("create-button")
  #     shinyjs::hide("create-warning-duplicated")
  #     hideTab("main", "create-tab")
  #   } else {
  #     shinyjs::show("create-button")
  #     # as.character()
  #     if(dir.exists(paste0(DP.location,DP.name))
  #        && nzchar(DP.name))
  #       shinyjs::show("create-warning-duplicated")
  #   }
  # })
 
  # on click on create-button
  observeEvent(input[["create-button"]], {
    createDPFolder(DP.location = outvar$dp.dir.choose(),
                   DP.name = input$dp.name,
                   data.location = outvar$data.dir.choose() )
    showTab("main", "create-tab", select = TRUE)
  })
  
  
}