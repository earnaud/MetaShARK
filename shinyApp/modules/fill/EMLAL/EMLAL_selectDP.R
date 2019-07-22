# EMLAL_functions.R

### UI ###
selectDPUI <- function(id, title, width=12, IM, DP.path){

  ns <- NS(id)
  
  # tmp
  if(length(list.files(DP.path))==0)
    DP.list <- "Sorry, yet no data package has been saved in this location"
  else
    DP.list <- list.files(DP.path)
  
  # UI output
  return(
      fluidPage(
        title = "1. Organize data packages",
        fluidRow(
          column(ceiling(width/3),
                 h4("Edit existing data package",
                    style="text-align:center"),
                 DP.list),
          column(floor(2*width/3),
            h4("Create new data package",
               style="text-align:center"),
            inputRow(
              id = ns("dp_name"),
              input_fun = textInput,
              input_args = list(label = "Data package name:",
                                placeholder = paste0("eml.datapackage.",
                                                     Sys.Date()))
            ),
            inputRow(
              id = ns("data_files"),
              input_fun = fileInput,
              input_args = list(label = "Select dataset files:",
                                buttonLabel = "Browse ...",
                                multiple = TRUE)
            ),
            inputRow(
              id = ns("license"),
              input_fun = selectInput,
              input_args = list(label = "Select a license:",
                                choices = c("CC BY","CC0"))
            )
            #----
            # inputRow(
            #   # DP name
            #   textInput(ns("dp_name_in"),
            #             "Enter a data package name:",
            #             placeholder=paste0("eml.datapackage.",
            #                                Sys.Date())),
            #   textOutput(ns("dp_name_out"))
            # ),
            # inputRow(
            #   # DP location
            #   div(tags$b("Select a data package output directory:"),
            #       actionButton(ns("dp_location_in"), "Browse ...")
            #   ),
            #   div(tags$b("Currently selected folder:"),
            #       div(
            #         style = "white-space: nowrap; text-overflow: ellipsis; overflow: hidden;",
            #         textOutput(ns("dp_location_out"))
            #         )
            #   )
            # ),
            # inputRow(
            #   # Data files
            #   fileInput(ns("data_files_in"), 
            #             "Select your data files (make sure they are in the same directory)",
            #             TRUE
            #   ),
            #   div(tags$b("Currently selected data files:"),
            #       tableOutput(ns("data_files_out"))
            #   )
            # ),
            # inputRow(
            #   # License choice
            #   selectInput("data_license_in",
            #               "Select a license of the dataset intellectual rights",
            #               c("CC BY","CC0")
            #   ),
            #   verbatimTextOutput("data_license_out")
            # ),
            # # DP creation
            # conditionalPanel(
            #   condition = "output.toggle_create_button",
            #   actionButton(ns("create_button"),"Create")
            # ),
            # # Warnings
            # conditionalPanel(
            #   condition = "output.warnings_duplicata",
            #   div(style="color:red;",
            #       span("WARNING: such a data package already exists (same name, same location).",br(),
            #            "Clicking 'Create' will replace all its content. (located in: ",
            #            textOutput(ns("dp_location_out"), inline = TRUE), textOutput(ns("dp_name_out"), inline = TRUE),")")
            #   )
            # )
          ) # end column2
        ) # end fluidRow
      ) # end fluidPage
    ) # end return
}

selectDP <- function(input, output, session, IM, DP.path){
  
  callModule(inputRowServer, "dp_name",
             renderText, alist(reactive(input$input)()) )
  callModule(inputRowServer, "data_files",
             renderTable, alist(reactive(input$input)()) ) 
  callModule(inputRowServer, "license",
             renderText, alist(reactive(input$input)()) ) 
  
  # outvar <- reactiveValues()
  # 
  # ## Metadata management
  # # DP name Output
  # outvar$dp_name_out <- reactive({input$dp_name_in})
  # output$dp_name_out <- renderText({ isolate(outvar$dp_name_out())})
  # 
  # 
  # 
  # # DP location Output
  # outvar$dp_location_out <- eventReactive(input$dp_location_in,
  #                                         {
  #                                           print("click")
  #                                           chooseDirectory()}
  #                                         )
  # output$dp_location_out <- renderText({outvar$dp_location_out()})
  # 
  # # Data files Output
  # outvar$data_files_out <- reactive({input$data_files_in})
  # output$data_files_out <- renderTable({outvar$data_files_out()})
  # 
  # # License choice Output
  # outvar$data_license_out <- reactive({input$data_license_in})
  # output$data_license_out <- renderText({outvar$data_license_out()})
  # 
  # ## Toggles
  # # reveal create-button
  # output$toggle_create_button <- renderText({
  #     r2js.boolean(outvar$dp_name_out() != ''
  #                  || !grepl("^[:alnum:_\\.-]+$", outvar$dp_name_out() )
  #                  || !is.null(outvar$data_files_out() )
  #                  )
  # })
  # outputOptions(output, "toggle_create_button", suspendWhenHidden = FALSE)
  # 
  # # reveal warning
  # output$warnings_duplicata <- renderText({
  #   r2js.boolean( dir.exists( paste0( outvar$dp_location_out(), outvar$dp_name_out() ) )
  #                && !is.null( outvar$dp_name_out() ) )
  # })
  # outputOptions(output, "warnings_duplicata", suspendWhenHidden = FALSE)
  # 
  # ## To next tab
  # # on click on create-button
  # observeEvent(input$create_button, {
  #   createDPFolder(DP.location = outvar$dp_location_out(),
  #                  DP.name = outvar$dp_name_out(),
  #                  data.location = outvar$data_files_out() )
  #   showTab("main", "create-tab", select = TRUE)
  # })
 
}