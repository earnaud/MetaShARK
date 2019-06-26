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
                # DP input
                div(id="dp.input", 
                    style="border: 1px solid lightgrey;
                    margin: 5px;
                    padding: 5px;
                    width: 100%;",
                    # DP name
                    textInput(ns("dp.name"),
                              "Enter a data package name:",
                              placeholder=paste0("eml.datapackage.",
                                                 Sys.Date())),
                    # DP location
                    tags$b("Select a data package directory output:"),
                    actionButton(ns("dp.dir.browse"), "Browse ..."),
                    div(id = ns("dp.dir.choose"),
                        tags$b("Currently selected folder:"),
                        br(),
                        textOutput(ns("dp.dir.choose")), 
                        style = "white-space: nowrap;
                            text-overflow: ellipsis;
                            overflow: hidden;"
                    )
                  ),
                # Data input
                div(id="data.input", 
                    style="border: 1px solid lightgrey;
                    margin: 5px;
                    padding: 5px;
                    width: 100%;",
                  # Data files
                  fileInput(ns("data.files.browse"), 
                            "Select your data files (make sure they are in the same directory)",
                            TRUE),
                  div(tags$b("Currently selected data files:"),
                      tableOutput(ns("data.files.choose")),
                      style = "white-space: nowrap;
                               text-overflow: ellipsis;
                               overflow: hidden;"
                  ),
                  # License choice
                  selectInput("data.license", "Select a license of the dataset intellectual rights",
                              c("CC BY","CC0"))
                ),
                # DP creation
                conditionalPanel(
                  condition = "output.toggle_create_button",
                  actionButton(ns("create-button"),"Create")
                ),
                # Warnings
                conditionalPanel(
                  condition = "output.warnings_duplicata",
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
  outvar = reactiveValues()
  
  # select DP name
  outvar$dp.name <- reactive({input$dp.name})
  output$dp.name <- renderText({ outvar$dp.name })
  
  # select DP directory
  output$dp.dir.choose <- renderText({ DP.path })
  
  observeEvent(input$dp.dir.browse, {
    outvar$dp.dir.choose <- chooseDirectory()
    if(is.na(outvar$dp.dir.choose))
      outvar$dp.dir.choose <- renderText({ DP.path })
    output$dp.dir.choose <- outvar$dp.dir.choose
  })
  
  # select Data files
  outvar$data.files.choose <- reactive({
    ifelse(is.null(input$data.files.browse),
           return(data.frame(NULL)),
           return(input$data.files.browse))
      
  })
  
  output$data.files.choose <- renderTable({
    return( outvar$data.files.choose() )
  })

  ## Toggles
  # reveal create-button if
  # - 
  output$toggle_create_button <- renderText({
    r2js.boolean(outvar$dp.name != ''
                 || !grepl("^[:alnum:_\\.-]+$", outvar$dp.name)
                 || !is.null(outvar$data.files.choose)
                 )
  })
  
  # reveal warning if:
  # - not such a directory exists BUT there is at least a directory name given
  output$warnings_duplicata <- renderText({
    r2js.boolean(dir.exists(paste0(outvar$dp.dir.choose, input$dp.name)) && !is.null(input$dp.name))
  })
  outputOptions(output, "warnings_duplicata", suspendWhenHidden = FALSE)
 
  # on click on create-button
  observeEvent(input[["create-button"]], {
    createDPFolder(DP.location = outvar$dp.dir.choose(),
                   DP.name = input$dp.name,
                   data.location = outvar$data.dir.choose() )
    showTab("main", "create-tab", select = TRUE)
  })
  
  
}