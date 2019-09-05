# EMLAL_functions.R

### UI ###
selectDPUI <- function(id, title, width=12, IM, DP.path){
  ns <- NS(id)
  
  # UI output
  return(
    fluidPage(
      title = "Organize data packages",
      # Data package location
      fluidRow(
        actionButton(ns("dp_location"), "Choose directory"),
        textOutput(ns("dp_location")),
        style=paste(inputStyle, "display:inline-block;")
      ),
      fluidRow(
        # Use existing DP
        column(ceiling(width/2),
               h4("Edit existing data package",
                  style="text-align:center"),
               uiOutput(ns("dp_list")),
               actionButton(ns("dp_load"), "Load"),
               actionButton(ns("dp_delete"),"Delete")
        ),
        # Create DP
        column(floor(width/2),
               h4("Create new data package",
                  style="text-align:center"),

               # Data package title
               textInput(ns("dp_name"), "Data package name",
                         placeholder = paste0(Sys.Date(),"_project")),
               textOutput(ns("warning_dp_name")),
               # DP creation
               actionButton(ns("dp_create"),"Create")
       ) # end column2

      ) # end fluidRow
      
    ) # end fluidPage
    
  ) # end return
  
}

selectDP <- function(input, output, session, IM, DP.path){
  
  # variable initialization
  ns <- session$ns
  parent_ns = NS(IM.EMLAL[1])
  hideElement(selector = paste0("#EMLALModule-main li a[data-value=create-tab]"))
  
  
  outvar <- reactiveValues(
    dp_location = NULL,
    dp_name = NULL
  )
  rv <- reactiveValues(
    dp_list = NULL,
    warning_dp_name = NULL
  )
  navigate <- reactiveValues(
    move = NULL
  )
  
  # DP location ----
  outvar$dp_location <- DP.path
  
  observeEvent(input$dp_location, {
    save <- outvar$dp_location
    outvar$dp_location <- chooseDirectory(default = DP.path)
    if(is.na(outvar$dp_location))
      outvar$dp_location <- save
  })
  
  output$dp_location <- renderText({
    outvar$dp_location
  })
  
  # DP list in location ----
  observeEvent(outvar$dp_location, {
    dpList <- list.files(outvar$dp_location)
    dpList <- dpList[grepl("_emldp$", dpList)]
    if(length(dpList) == 0) dpList <- NULL
    rv$dp_list <- dpList
  })
  
  output$dp_list <- renderUI({
    if(!is.null(rv$dp_list))
       radioButtons(ns("dp_list"),
                    NULL,
                    choiceNames = c("None selected",rv$dp_list),
                    choiceValues = c("", rv$dp_list)
                    )
    else{
      disable("dp_load")
      disable("dp_delete")
      "No EML data package was found at this location."
    }

  })
  
  observeEvent(input$dp_list, {
    if(input$dp_list != ""){
      enable("dp_load")
      enable("dp_delete")
    }
    else{
      disable("dp_load")
      disable("dp_delete")
    }
  })  
  
  # DP name ----
  observeEvent(input$dp_name, {
    # name validity test
    rv$warning_dp_name <- c(
      ifelse(nchar(input$dp_name) < 3,
             "Please type a name with at least 3 characters.",
             ""),
      ifelse(!grepl("^[[:alnum:]_\\.-]+$",input$dp_name) && nzchar(input$dp_name),
             "Only authorized characters are alphanumeric, '.' (dot), '_' (underscore) and '-' (hyphen).",
             "")
    )
    outvar$dp_name <- paste0(input$dp_name,"_emldp")
    
    # control button
    if(sum(nchar(rv$warning_dp_name)) == 0)
      enable("dp_create")
    else
      disable("dp.create")
  })

  output$warning_dp_name <- renderText({
    if(sum(nchar(rv$warning_dp_name)) == 0)
      return(NULL)
    else
      return(paste(c(rv$warning_dp_name,""), collapse = "\n"))
  })
  
  # DP management ----
  observeEvent(input$dp_create, {
    req(input$dp_name)
    
    dp <- outvar$dp_name
    path <- outvar$dp_location
    
    cat("Creating:",dp,"\nAt:",path,"\n")
    
    # dir.create(paste0(path,dp))
    template_directories(
      path,
      dp
    )
    rv$dp_list <- c(rv$dp_list,dp)
    navigate$move <- "next"
    showElement(selector = paste0("#EMLALModule-main li a[data-value=create-tab]"))
  })
  
  # Load DP
  observeEvent(input$dp_load, {
    req(input$dp_list)
    
    dp <- input$dp_list
    path <- outvar$dp_location
    cat("Loading:",dp,"\nAt:",path,"\n") # to replace by loading DP
    
    navigate$move <- "next"
    showElement(selector = paste0("#EMLALModule-main li a[data-value=create-tab]"))
  })
  
  # Delete DP -- need to trigger the dpList
  observeEvent(input$dp_delete, {
    req(input$dp_list)
    
    dp <- input$dp_list
    path <- outvar$dp_location
    cat("Deleting:",dp,"\nAt:",path,"\n") # to replace by deleting DP
    unlink(paste0(path,dp), recursive = TRUE)
    rv$dp_list <- rv$dp_list[rv$dp_list != dp]
  })
  
  return(list(navigate = navigate,
              outvar = outvar)
         )
}