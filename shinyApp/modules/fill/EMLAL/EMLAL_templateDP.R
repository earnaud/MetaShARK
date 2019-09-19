# EMLAL_templateDP.R

## 3. Create DP template
templateDPUI <- function(id, title, IM){
  ns <- NS(id)

  return(
    fluidPage(
      # Inputs ----
      column(10,
             uiOutput(ns("fill_template"))
      ),
      
      # Navigation buttons ----
      column(2,
             h4("Navigation"),
             quitButton(ns(id), style = rightButtonStyle),
             saveButton(ns(id), style = rightButtonStyle),
             # actionButton(ns("nextTab"),"Next",
             #              icon = icon("arrow-right"),
             #              style = rightButtonStyle),
             actionButton(ns("prevTab"),"Previous",
                          icon = icon("arrow-left"),
                          style = rightButtonStyle),
             style = "text-align: center; padding: 0;"
      ) # end column 2
    ) # end fluidPage
  ) # end return
  
}

templateDP <- function(input, output, session, IM, savevar, globalRV){
  ns <- session$ns
  
  # variable initialization ----
  rv <- reactiveValues(
    location = NULL,
    files_names = NULL
  )
  observe({
    rv$dp_location <- paste0(savevar$emlal$selectDP$dp_path,"/",
                          savevar$emlal$selectDP$dp_name)
    rv$dp_files_names <- savevar$emlal$createDP$dp_data_files$name
  })
  
  # Produce fill template UI
  output$fill_template <- renderUI({
    # load paths
    files <- tools::file_path_sans_ext(rv$dp_files_names)
    # read tables
    sapply(files, function(file){
      filepath <- paste0(rv$dp_location,
                         "/metadata_templates/attributes_",
                         file,
                         ".txt")
      DT <- fread(filepath)
      apply(DT, 1, function(row){
        tagList(
          h2(file),
          lapply(names(row), function(colname) {
            # prepare var
            input_id <- ns(paste0(file,row["attributeName"],collapse = "_"))
            unitList <- c("custom",get_unitList()$units$name)
            
            # process ui
            switch(colname,
                   attributeName = tags$b(row[colname]),
                   attributeDefinition = textAreaInput(input_id,
                                                       "Describe the attribute concisely"),
                   class = selectInput(input_id,
                                     "Detected class (change only in case of error)",
                                     choices = c("numeric","categorical","character","Date"),
                                     row[colname]),
                   unit = if(grepl("!Add.*here!",row[colname]))
                            tagList(selectInput(input_id, "Existing unit"),
                                    conditionalPanel(paste0("input.",input_id," == 'custom'"),
                                                     textInput(paste(input_id,"_custom"), "Custom unit")
                                                     )
                                    ),
                   dateTimeFormatString = if(grepl("!Add.*here!",row[colname]))
                                            tagList(textInput(input_id, "Date Format"),
                                                    conditionalPanel(paste0("input.",input_id,".match()"),
                                                                     "")),
                   missingValueCode,
                   missingValueCodeExplanation
            ) # end of switch
          }) # end of lapply colname
        ) # end of tagList
      }) # end of apply row
    }) # end of sapply files
    
  })
  
  # Navigation buttons ----
  callModule(onQuit, IM.EMLAL[5],
             # additional arguments
             globalRV, savevar,
             savevar$emlal$selectDP$dp_path, 
             savevar$emlal$selectDP$dp_name)
  callModule(onSave, IM.EMLAL[5],
             # additional arguments
             savevar,
             savevar$emlal$selectDP$dp_path, 
             savevar$emlal$selectDP$dp_name)
  observeEvent(input$nextTab, {
    globalRV$navigate <- globalRV$navigate+1
    globalRV$previous <- "template"
  })
  observeEvent(input$prevTab, {
    globalRV$navigate <- globalRV$navigate-1
    globalRV$previous <- "template"
  })
  
  # Output ----
  return(savevar)
}