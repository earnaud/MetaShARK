# EMLAL_create.R

## 2. CREATE DATA PACKAGE
createDPUI <- function(id, title, IM){
  ns <- NS(id)
  
  return(
      fluidPage(
        column(10,
               h4("Data files"),
               HTML("When selecting your files, you can't select
                    folders. You can delete file(s) from your 
                    selection by ticking their box and clicking 
                    the 'Remove' button.<br>"),
               div(
                 shinyFilesButton(ns("add_data_files"),
                                  "Load files",
                                  "Select data file(s) from your dataset",
                                  multiple = TRUE,
                                  icon = icon("plus-circle")),
                 style = "display: inline-block; vertical-align: top;"
               ),
               actionButton(ns("remove_data_files"),"Remove",
                            icon = icon("minus-circle"), 
                            style = redButtonStyle),
               uiOutput(ns("data_files"))
        ), # end of column 1
        column(2,
               h4("Navigation"),
               quitButton(ns(id), style = rightButtonStyle),
               saveButton(ns(id), style = rightButtonStyle),
               actionButton(ns("nextTab"),"Next",
                            icon = icon("arrow-right"),
                            style = rightButtonStyle),
               textOutput(ns("warning_data_size")),
               textOutput(ns("overwrite")),
               style = "text-align: center; padding: 0;"
        ) # end of column 2
      ) # end fluidPage
    ) # end return
}

createDP <- function(input, output, session, IM, savevar, globalRV){
  ns <- session$ns
  
  # Variable initialization ----
  rv <- reactiveValues(
    # to save
    dp_data_files = data.frame()
    # local only
  )
  volumes <- c(Home = HOME, getVolumes()())
  updateFileListTrigger <- makeReactiveTrigger()
  
  # On arrival on screen
  observeEvent(globalRV$previous, {
    updateFileListTrigger$trigger()
    # dev: might evolve in `switch` if needed furtherly
    rv$dp_data_files <- if(globalRV$previous == "create")
                          data.frame()
                        else
                          savevar$emlal$createDP$dp_data_files
  })
  
  # Navigation buttons ----
  callModule(onQuit, IM.EMLAL[4],
             # additional arguments
             globalRV, savevar,
             savevar$emlal$selectDP$dp_path, 
             savevar$emlal$selectDP$dp_name)
  callModule(onSave, IM.EMLAL[4],
             # additional arguments
             savevar, 
             savevar$emlal$selectDP$dp_path, 
             savevar$emlal$selectDP$dp_name)
  observeEvent(input$nextTab, {
    savevar$emlal$createDP$dp_data_files <- rv$dp_data_files
    globalRV$navigate <- globalRV$navigate+1
    globalRV$previous <- "create"
  })
  
  # Data file upload ----
  # Add data files
  shinyFileChoose(input, "add_data_files",
                  roots = volumes,
                  # defaultRoot = HOME,
                  session = session)
  
  observeEvent(input$add_data_files,{
    # validity checks
    req(input$add_data_files)
    
    # actions
    loadedFiles <- as.data.frame(
      parseFilePaths(volumes, input$add_data_files)
    )
    
    if(identical(rv$dp_data_files, data.frame()))
      rv$dp_data_files <- loadedFiles
    else{
      for(filename in loadedFiles$name){
        if(!grepl("\\.",filename))
          message(filename," is a folder.")
        else
          rv$dp_data_files <- unique(rbind(rv$dp_data_files,
                                           loadedFiles[loadedFiles$name == filename,])
                                    )
      }
    }
  })
  
  # Remove data files
  observeEvent(input$remove_data_files, {
    
    # validity check
    req(input$select_data_files)
    
    # actions
    rv$dp_data_files <- rv$dp_data_files[
      rv$dp_data_files$name != input$select_data_files
      ,]
  })
  
  # Display data files
  output$data_files <- renderUI({
    
    updateFileListTrigger$depend()
        
    # variable modifications
    savevar$emlal$createDP$dp_data_files <- rv$dp_data_files

    # actions
    if(!identical(rv$dp_data_files, data.frame()) &&
       !is.null(rv$dp_data_files)){
      enable("nextTab")
      checkboxGroupInput(ns("select_data_files"),
                         "Select files to delete (all files here will be kept otherwise)",
                         choices = rv$dp_data_files$name)
      
    }
    else{
      disable("nextTab")
      return(NULL)
    }
  })
  
  # Warnings ----
  # data size
  output$warning_data_size <- renderText({
    if(sum(rv$dp_data_files$size) > THRESHOLD$dp_data_files)
      paste("WARNING:", sum(rv$dp_data_files$size),
            "are about to be duplicated for data package assembly")
    else
      ""
  })
  
  # overwrite files
  output$warning_overwrite <- renderText({
    if(identical(dir(paste0(path,"/",dp,"/data_objects/")),
                 character(0))
       )
      paste("WARNING:", "Selected files will overwrite
            already loaded ones.")
    else
      ""
  })
  
  # Process files ----
  # Template table
  observeEvent(input$nextTab, {
    # fetch location
    dp <- savevar$emlal$selectDP$dp_name
    path <- savevar$emlal$selectDP$dp_path
    
    # copy files to <dp>_emldp/<dp>/data_objects
    sapply(rv$dp_data_files$datapath,
           file.copy, 
           to = paste0(path,"/",dp,"/data_objects/"),
           overwrite = TRUE)
    template_table_attributes(
      path = paste0(path,"/",dp,"/metadata_templates"),
      data.path = paste0(path,"/",dp,"/data_objects"),
      data.table = rv$dp_data_files$name,
    )
  })
  
  # Output ----
  return(savevar)
}
