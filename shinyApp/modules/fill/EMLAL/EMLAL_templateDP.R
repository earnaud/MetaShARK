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
             # actionButton(ns("nextTab"),"Next",
             #              icon = icon("arrow-right"),
             #              style = rightButtonStyle),
             # actionButton(ns("prevTab"),"Previous",
             #              icon = icon("arrow-left"),
             #              style = rightButtonStyle),
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
    # to Save
    save = reactiveValues(),
    completed = FALSE
  )
  # local modules of rv
  observe({
    req(savevar$emlal$createDP$dp_data_files)
    rv$files_names <- savevar$emlal$createDP$dp_data_files$name
  })
  observeEvent(rv$files_names, {
    req(rv$files_names)
    rv$current_file <- rv$files_names[1]
  })
  
  # on file change
  observeEvent(rv$current_file, {
    req(rv$current_file) # already req savevar$..$dp_data_files^
    toRead <- savevar$emlal$createDP$dp_data_files
    toRead <- toRead$metadatapath[
                match(rv$current_file, toRead$name) ]
    rv$df_file <- fread(toRead, data.table = FALSE, 
                        stringsAsFactors = FALSE,
                        na.strings = NULL)
    rv$df_file[is.na(rv$df_file)] <- ""
    rv$current_attribute <- rv$df_file$attributeName[1]
  })
  
  # Selection file/attribute ----
  # -- files
  observeEvent(input$file_prev,{
    req(rv$save)
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind > 1){
      # save metadata
      rv <- saveAttribute(rv)
      # change file
      rv$current_file <- rv$files_names[cur_ind - 1]
    }
  })
  observeEvent(input$file_next,{
    req(rv$save)
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind < length(rv$files_names) ){
      # save metadata
      rv <- saveAttribute(rv)
      # change file
      rv$current_file <- rv$files_names[cur_ind + 1]
    }
  })
  # -- attribute
  observeEvent(input$attribute_prev,{
    req(rv$save)
    cur_ind <- match(rv$current_attribute,
                     rv$df_file$attributeName)
    if(cur_ind > 1){
      # save metadata
      rv <- saveAttribute(rv)
      # change attribute
      rv$current_attribute <- rv$df_file$attributeName[cur_ind - 1]
    }
  })
  observeEvent(input$attribute_next,{
    req(rv$save)
    cur_ind <- match(rv$current_attribute,
                     rv$df_file$attributeName)
    if(cur_ind < length(rv$df_file$attributeName)){
      # save metadata
      rv <- saveAttribute(rv)
      # change attribute
      rv$current_attribute <- rv$df_file$attributeName[cur_ind + 1]
    }
  })
  
  # regular saves in savevar - triggered in saveAttribute()
  observe({
    req(rv$df_file)
    savevar$emlal$templateDP[[rv$current_file]] <- rv$df_file
  })
    
  # outputs
  output$current_file <- renderUI(div(rv$current_file,
                                      style = "display: inline-block;
                                              font-size:20pt;
                                              text-align:center;
                                              width:70%;"
                                      )
                                  )
  output$current_attribute <- renderUI(div(rv$current_attribute,
                                           style = "display: inline-block;
                                                  font-size:15pt;
                                                  text-align:center;
                                                  width:70%;"
                                           )
                                       )
  
  # Procedurals / ----
  # / UI ----
    output$edit_template <- renderUI({
      # prepare variables
      row <- rv$df_file[rv$df_file[1] == rv$current_attribute,]
      
      # actions
      tagList(
        # write each attribute's characteristic
        lapply(names(row), function(colname) {
          # prepare var
          # input_id <- buildInputID(rv$current_file, 
          #                          rv$current_attribute,
          #                          colname)
          input_id <- colname
          
          # UI
          switch(colname,
                 # attributeName = h3(row[colname]),
                 attributeDefinition = textAreaInput(ns(input_id),
                                                     "Describe the attribute concisely"),
                 class = HTML(paste("<b>Detected class:</b>", as.vector(row[colname]) ) ),
                 unit = if(row[colname] != ""
                           || grepl("!Add.*here!", row[colname])){
                   tagList(selectInput(ns(input_id), 
                                       span("Existing unit", style=redButtonStyle),
                                       c("",UNIT.LIST), # blank choice
                                       selected = if(row[colname] %in% c("",UNIT.LIST)) row[colname]
                                       else ""
                   ),
                   uiOutput(ns(paste0(input_id,"_custom")))
                   # , if(input[[input_id]] == "custom")
                   #   customUnitsUI(input_id)
                   # else
                   #   NULL
                   # uiOutput(paste0(input_id,"_custom"))
                   )
                 },
                 dateTimeFormatString = if(row[colname] != ""
                                           || grepl("!Add.*here!", row[colname])){
                   tagList(selectInput(ns( paste0(input_id,"_date") ),
                                       span("Existing date format",
                                            style=redButtonStyle),
                                       DATE.FORMAT,
                                       selected = if(row[colname] %in% DATE.FORMAT) row[colname]
                                       else DATE.FORMAT[1]),
                           selectInput(ns( paste0(input_id,"_hour") ),
                                       "Existing hour format",
                                       HOUR.FORMAT)
                   )
                 },
                 missingValueCode = textInput(ns(input_id), "Code for missing value"),
                 missingValueCodeExplanation = textAreaInput(ns(input_id),
                                                             "Explain Missing Values")
          ) # end of switch
        }) # end of lapply colname
      ) # end of tagList
    })
    
  # / Servers ----
    # general case
    observe({
      # prepare variables
      rv$save <- reactiveValues()
      row <- rv$df_file[rv$df_file[1] == rv$current_attribute,]
      
      # write each attribute's characteristic
      lapply(names(row), function(colname) {
        # prepare var
        # input_id <- buildInputID(rv$current_file,
        #                          row["attributeName"],
        #                          colname)
        input_id <- colname
        
        if( !is.null(input[[input_id]]) ){
          rv$save[[colname]] <- eventReactive(input[[input_id]], {
            
            # enter <- switch(colname,
            #                  dateTimeFormatString = paste(input[[paste0(input_id,"_date")]],
            #                                               ifelse(is.na(input[[paste0(input_id,"_hour")]]),
            #                                                      row[colname], # unchanged
            #                                                      input[[paste0(input_id,"_hour")]] 
            #                                               )
            #                  ),
            #                  unit = paste(input[[input_id]],
            #                               ifelse(is.na(input[[paste0(input_id, "_custom")]]),
            #                                      row[colname], # unchanged
            #                                      input[[paste0(input_id, "_custom")]] 
            #                               )
            #                  ),
            #                  input[[input_id]]
            # ) # end switch
            
            # alt
            enter <- if(colname == "dateTimeFormatString")
                       paste(input[[paste0(input_id,"_date")]],
                             ifelse(is.na(input[[paste0(input_id,"_hour")]]),
                                    row[colname], # unchanged
                                    input[[paste0(input_id,"_hour")]]
                                    )
                             )
                     else
                       input[[input_id]]
            
            if(is.list(enter))
              enter <- unlist(enter)
            if(!isTruthy(enter)){
              enter <- ifelse(isTruthy(unlist(row[colname])),
                              unlist(row[colname]),
                              ""
              )
            } # end if
            enter
          }) # end eventReactive
        } # end if
        
    }) # end lapply
      
  }) # end observe
  
  # custom units case - reactive UI as output
  curt <- makeReactiveTrigger()
  
  # renderUI
  observe({
    # validity check
    req(input$unit)
    
    # actions
    if(req(input$unit) == "custom"){
      cat("UI\n")
      output$unit_custom <- renderUI({
        # customUnitsUI("unit", customUnitsTable)
        tagList(
          column(1),
          column(11,
                 lapply(c("id","unitType","parentSI","multiplierToSI","description"),
                        function(field){
                          id <- ns(paste0("custom_",field))
                          switch(field,
                                 id = textInput(id,
                                                span("Type an ID for your custom unit", style = redButtonStyle),
                                                placeholder = "e.g.  gramsPerSquaredMeterPerCentimeter "),
                                 unitType = textInput(id,
                                                      span("Type the scientific dimension using this unit in your dataset", style = redButtonStyle),
                                                      placeholder = "e.g. mass, areal mass density per length"),
                                 parentSI = selectInput(id,
                                                        span("Select the parent SI from which your unit is derivated",style = redButtonStyle),
                                                        unique(get_unitList()$units$parentSI)),
                                 multiplierToSI = numericInput(id,
                                                               span("Type the appropriate numeric to multiply a value by to perform conversion to SI",style = redButtonStyle),
                                                               value = 1),
                                 description = textAreaInput(id,
                                                             "Describe your custom unit")
                          )
                        }) # end of lapply
          )
        ) # end of taglist
      })
    }
    else{
      output$unit_custom <-NULL
    }
    # trigger server output
    # curt$trigger()
  }) # end observe
  
  # Server
  observe({
    # trigger
    # curt$depend()
    
    # validity check 
    # input set to 1
    if(!is.null(req(input$custom_multiplierToSI))){
      cat("server\n")
      # prepare variable
      if(is.null(savevar$emlal$templateDP$customUnitsTable))
        savevar$emlal$templateDP$customUnitsTable <- fread(paste(savevar$emlal$selectDP$dp_path,
                                                                 savevar$emlal$selectDP$dp_name,
                                                                 "metadata_templates",
                                                                 "custom_units.txt",
                                                                 sep = "/")
                                                           )
      # end of fread
      customUnitsTable <- savevar$emlal$templateDP$customUnitsTable
      
      rv$save$custom_units <- reactiveValues()
      
      # action
      lapply(colnames(customUnitsTable),
             function(field){
               id <- paste0("custom_",field)
               rv$save$custom_units[[id]] <- reactive({ input[[id]] })
             })
      # rv$save$custom_units <- callModule(customUnits, 
      #                                    "unit", 
      #                                    savevar)
    }
  }) # end observe
  
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
  callModule(nextTab, IM.EMLAL[5],
             globalRV, "template")
  callModule(prevTab, IM.EMLAL[5],
             globalRV, "template")
  # observeEvent(input$nextTab, {
  #   globalRV$navigate <- globalRV$navigate+1
  #   globalRV$previous <- "template"
  # })
  # observeEvent(input$prevTab, {
  #   globalRV$navigate <- globalRV$navigate-1
  #   globalRV$previous <- "template"
  # })
  
  # Completeness check ----
  observeEvent(rv$df_file,{
    tmp_df <- rv$df_file[,c("attributeName","class","dateTimeFormatString","unit")]
    if(all(sapply(unlist(tmp_df),
               function(td){
                 (
                   isTruthy(td)
                   && !grepl("!Add.*here!",td)
                 )
               })
        )
    )
      rv$completed = TRUE
    else
    rv$completed = FALSE
  })
  # allow nexTab progression
  observeEvent(rv$completed,{
    if(rv$completed)
      enable(ns("nextTab"))
    else
      disable(ns("nextTab"))
  })
  
  # Output ----
  return(savevar)
}