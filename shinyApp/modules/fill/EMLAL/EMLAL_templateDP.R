# EMLAL_templateDP.R

## 3. Create DP template
templateDPUI <- function(id, title, IM){
  ns <- NS(id)
  
  return(
    fluidPage(
      # Inputs ----
      column(10,
             h4("Data table attributes"),
             HTML("Even if EML Assembly Line automatically infers most
                  of your data's metadata, some steps need you to check
                  out. Please check the following attribute, and fill 
                  in at least the <span style='color:red;'>mandatory
                  </span> elements."),
             # uiOutput(ns("fill_template"))
             fluidRow(
               tagList(
                 actionButton(ns("file_prev"),
                              "",
                              icon("chevron-left"),
                              width = "12%"),
                 uiOutput(ns("current_file"),
                          inline = TRUE),
                 actionButton(ns("file_next"),
                              "",
                              icon("chevron-right"),
                              width = "12%")
               )
             ),
             fluidRow(
               tagList(
                 actionButton(ns("attribute_prev"),
                              "",
                              icon("chevron-left"),
                              width = "12%"),
                 uiOutput(ns("current_attribute"),
                          inline = TRUE),
                 actionButton(ns("attribute_next"),
                              "",
                              icon("chevron-right"),
                              width = "12%")
               ),
               uiOutput(ns("edit_template"))
             )
      ),
      
      # Navigation buttons ----
      column(2,
             h4("Navigation"),
             quitButton(ns(id), style = rightButtonStyle),
             saveButton(ns(id), style = rightButtonStyle),
             nextTabButton(ns(id), style = rightButtonStyle),
             prevTabButton(ns(id), style = rightButtonStyle),
             style = "text-align: center; padding: 0;"
             ,actionButton(ns("check2"),"Dev Check")
      ) # end column 2
    ) # end fluidPage
  ) # end return
  
}

templateDP <- function(input, output, session, IM, savevar, globalRV){
  ns <- session$ns
  
  observeEvent(input$check2,{
    browser()
  })
  # variable initialization ----
  # main local reactiveValues
  rv <- reactiveValues(
    # local save
    attributes = reactiveValues(),
    customUnits = reactiveValues()
    # utility
  )
  
  observe({
    req(savevar$emlal$createDP$dp_data_files)
    rv$files_names <- savevar$emlal$createDP$dp_data_files$name
    
    if(is.null(savevar$emlal$templateDP$customUnitsTable)){
      tmp <- fread(paste(savevar$emlal$selectDP$dp_path,
                         savevar$emlal$selectDP$dp_name,
                         "metadata_templates",
                         "custom_units.txt",
                         sep = "/"),
                   data.table = FALSE)
      if(min(dim(tmp)) == 0) tmp <- tmp[1,]
      savevar$emlal$templateDP$customUnitsTable <- rv$customUnitsTable <- tmp
    }
  })
  observeEvent(rv$files_names, {
    req(rv$files_names)
    rv$current_file <- rv$files_names[1]
  })
  
  # on file change
  observeEvent(rv$current_file, {
    req(rv$current_file, rv$customUnitsTable) # already req savevar$..$dp_data_files
    toRead <- savevar$emlal$createDP$dp_data_files
    toRead <- toRead$metadatapath[
      match(rv$current_file, toRead$name)
      ]
    # load attributes_table.txt
    rv$attributesTable <- fread(toRead, data.table = FALSE, 
                                stringsAsFactors = FALSE,
                                na.strings = NULL)
    rv$attributesTable[is.na(rv$attributesTable)] <- ""
    # get current attribute
    rv$current_attribute <- 1
  })
  observeEvent(rv$current_attribute, {
    req(rv$attributesTable, rv$customUnitsTable)
    print("RV SET TO NULL") # ----
    
    # (re)set local save reactive value with NULL values
    sapply(colnames(rv$attributesTable), function(nn){
      rv$attributes[[nn]] <- NULL
    })
    sapply(colnames(rv$customUnitsTable), function(nn){
      rv$customUnits[[nn]] <- NULL
    })
  })
  
  # Navigation buttons ----
  # ** files
  observeEvent(input$file_prev,{
    req(rv$attributes, rv$customUnits)
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind > 1){
      # save metadata
      rv <- saveInput(rv)
      # change file
      rv$current_file <- rv$files_names[cur_ind - 1]
    }
  })
  observeEvent(input$file_next,{
    req(rv$attributes, rv$customUnits)
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind < length(rv$files_names) ){
      # save metadata
      rv <- saveInput(rv)
      # change file
      rv$current_file <- rv$files_names[cur_ind + 1]
    }
  })
  # ** attribute
  observeEvent(input$attribute_prev,{
    req(rv$attributes, rv$customUnits)
    if(rv$current_attribute > 1){
      # save metadata
      rv <- saveInput(rv)
      # change attribute
      rv$current_attribute <- rv$current_attribute - 1
    }
  })
  observeEvent(input$attribute_next,{
    req(rv$attributes, rv$customUnits)
    if(rv$current_attribute < length(rv$attributesTable$attributeName)){
      # save metadata
      rv <- saveInput(rv)
      # change attribute
      rv$current_attribute <- rv$current_attribute + 1
    }
  })
  
  # regular saves in savevar - triggered in saveInput()
  observeEvent({
    input$file_prev
    input$file_next
    input$attribute_prev
    input$attribute_next
  },{
    savevar$emlal$templateDP[[rv$current_file]] <- rv$attributesTable
  })
  
  # outputs
  {
    output$current_file <- renderUI(div(rv$current_file,
                                        style = "display: inline-block;
                                                font-size:20pt;
                                                text-align:center;
                                                width:70%;"
    )
    )
    output$current_attribute <- renderUI(div(rv$attributesTable[rv$current_attribute,"attributeName"],
                                             style = "display: inline-block;
                                                    font-size:15pt;
                                                    text-align:center;
                                                    width:70%;"
    )
    )
  }
  
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
  callModule(nextTab, IM.EMLAL[5],
             globalRV, "template")
  callModule(prevTab, IM.EMLAL[5],
             globalRV, "template")
  
  
  # Procedurals / ----
  # / UI ----
  output$edit_template <- renderUI({
    # actions
    tagList(
      # write each attribute's characteristic
      lapply(colnames(rv$attributesTable), function(colname) {
        # prepare var
        if(length(rv$attributesTable[rv$current_attribute, colname]) == 0)
          browser()
        saved_value <- rv$attributesTable[rv$current_attribute, colname]
        
        # UI
        switch(colname,
               attributeDefinition = textAreaInput(ns(colname), value = saved_value,
                                                   "Describe the attribute concisely"),
               class = HTML(paste("<b>Detected class:</b>", as.vector(saved_value) ) ),
               unit = tagList(selectInput(ns(colname), 
                                          span("Existing unit", style=redButtonStyle),
                                          c(saved_value,UNIT.LIST),
                                          selected = if(saved_value == "custom")
                                            "custom"
               ), # end of selectInput
               shinyjs::hidden(
                 div(id = "custom_units_ui",
                     column(1),
                     column(11,
                            tagList(
                              lapply(names(rv$customUnitsTable),
                                     function(field){
                                       switch(field,
                                              id = textInput(ns(field),
                                                             span("Type an ID for your custom unit", style = redButtonStyle),
                                                             placeholder = "e.g.  gramsPerSquaredMeterPerCentimeter "),
                                              unitType = textInput(ns(field),
                                                                   span("Type the scientific dimension using this unit in your dataset", style = redButtonStyle),
                                                                   placeholder = "e.g. mass, areal mass density per length"),
                                              parentSI = selectInput(ns(field),
                                                                     span("Select the parent SI from which your unit is derivated",style = redButtonStyle),
                                                                     unique(get_unitList()$units$parentSI)),
                                              multiplierToSI = numericInput(ns(field),
                                                                            span("Type the appropriate numeric to multiply a value by to perform conversion to SI",style = redButtonStyle),
                                                                            value = 1),
                                              description = textAreaInput(ns(field),
                                                                          "Describe your custom unit")
                                       )
                                     }) # end of lapply
                            ) # end of column
                     )  # end of CU taglist
                 ) # end of CU div
               ) # end of hidden
               ), # end of unit taglist
               dateTimeFormatString = tagList(selectInput(ns( paste0(colname,"_date") ),
                                                          span("Existing date format",
                                                               style=redButtonStyle),
                                                          DATE.FORMAT,
                                                          selected = if(gsub("(.*) ","\\1",saved_value) %in% DATE.FORMAT)
                                                            gsub("(.*) ","\\1",saved_value)
                                                          else
                                                            DATE.FORMAT[1] ),
                                              selectInput(ns( paste0(colname,"_hour") ),
                                                          "Existing hour format",
                                                          HOUR.FORMAT )
               ),
               missingValueCode = textInput(ns(colname), 
                                            "Code for missing value",
                                            value = saved_value),
               missingValueCodeExplanation = textAreaInput(ns(colname),
                                                           "Explain Missing Values",
                                                           value = saved_value)
        ) # end of switch
      }) # end of lapply colname
    ) # end of tagList
  })
  
  
  # / Servers / ----
  observe({
    req( any(names(rv$attributes) %in% names(input)) )
    print("SET TO REACTIVES")
    
    # / attributes ----
    sapply(names(rv$attributes), function(rvName) {
      # prepare variable
      # two different names: ids from input can be suffixed
      inputNames <- names(input)[
        which(grepl(rvName, names(input)))
        ]
      # 'unit' exception:
      if(rvName == "unit")
        inputNames <- inputNames[inputNames != "unitType"]
      
      # check corresponding input
      if(length(inputNames) != 0){
        
        if(
          (grepl("attributeDef|missingValue", rvName))
          || (grepl("date", inputNames)
              && grepl(".+", rv$attributesTable[rv$current_attribute, rvName] ))
          || (grepl("^unit", inputNames)
              && grepl(".+", rv$attributesTable[rv$current_attribute, rvName] ))
        ){
          # show UI
          sapply(inputNames, shinyjs::showElement)
# cat("Show:", inputNames,"\n")
          
          # Input UI yet exists: create eventReactive
          rv$attributes[[rvName]] <- eventReactive({
            if(rvName == "dateTimeFormatString"){
              if(is.na(input[[paste0(rvName,"_hour")]])
                 || input[[paste0(rvName,"_hour")]] == "NA")
              {
                input[[paste0(rvName,"_date")]]
              }
              else
              {
                input[[paste0(rvName,"_date")]]
                input[[paste0(rvName,"_hour")]]
              }
            }
            else{
              input[[rvName]]
            }
          },{
            # get input value
            enter <- if(rvName == "dateTimeFormatString"){
              if(is.na(input[[paste0(rvName,"_hour")]])
                 || input[[paste0(rvName,"_hour")]] == "NA")
                input[[paste0(rvName,"_date")]]
              else
                paste(input[[paste0(rvName,"_date")]],
                      input[[paste0(rvName,"_hour")]],
                      sep = " " # make sure
                )
            }
            else if(rvName == "unit"
                    && input[[rvName]] == "custom")
              input[["id"]] # link to custom inputs
            else
              input[[rvName]]
            
            # check obtained value
            if(is.list(enter))
              enter <- unlist(enter)
            if(!isTruthy(enter)){
              message("Input [",rvName,"] is invalid: unchanged")
              enter <- ifelse(isTruthy(unlist(rv$attributesTable[rv$current_attribute,rvName])),
                              unlist(rv$attributesTable[rv$current_attribute,rvName]),
                              ""
              )
            } # end if
            enter
          }) # end of eventReactive
        }
        else{
          # hide UI
          sapply(inputNames, shinyjs::hideElement)
# cat("Hide:", inputNames,"\n")
          # set reactiveValue to NULL
          rv$attributes[[rvName]] <- rv$attributesTable[rv$current_attribute, rvName]
        }
      } # end if inputNames == character(0)
      else{
        rv$attributes[[rvName]] <- rv$attributesTable[rv$current_attribute, rvName]
      }
    }) # end sapply
    
    # / custom units ----
    # show/hide custom units
    observeEvent(input$unit,{
      if(
        input$unit == "custom"
      ){
        # show UI
        show("custom_units_ui")
        
        # set reactives
        lapply(customFields, function(cc){
          rv$customUnits[[cc]] <- eventReactive(input[[cc]],{
            input[[cc]]
          }) # end of eventReactive
        }) # end of lapply
      }
      else{
        # hide UI
        hide("custom_units_ui")
        
        # set reactives to NULL
        rv$customUnits <- reactiveValues()
      }
    })
    
  })
  
  # Output ----
  return(savevar)
}