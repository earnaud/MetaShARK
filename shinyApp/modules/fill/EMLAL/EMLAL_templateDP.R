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
                               width = "12%"),
                  uiOutput(ns("edit_template"))
                )
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
  rv <- reactiveValues(
    # to Save
    save = reactiveValues(),
    # local
    location = c(),
    files_names = c(),
    current_file = c(),
    current_attribute = c(),
    completed = FALSE
  )
  # gather information
  observe({
    if(!identical(savevar, initReactive())){
      rv$location <- paste0(savevar$emlal$selectDP$dp_path,"/",
                            savevar$emlal$selectDP$dp_name)
      rv$files_names <- savevar$emlal$createDP$dp_data_files$name
      rv$current_file <- rv$files_names[1]
    }
  })
  # 
  observe({
    req(rv$current_file,
        savevar$emlal$createDP$dp_data_files$metadatapath)
    toRead <- savevar$emlal$createDP$dp_data_files
    toRead <- toRead$metadatapath[match(rv$current_file,toRead$name)]
    rv$df_file <- fread(toRead, data.table = FALSE)
    cat("evaluated\n")
    rv$current_attribute <- rv$df_file[1,"attributeName"]
  })
  
  # Selection file/attribute ----
  # -- files
  observeEvent(input$file_prev,{
    req(rv$save)
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind > 1){
      # save metadata
      out <- saveAttribute(savevar, rv)
      savevar <- out$s
      rv <- out$r
      # change file
      rv$current_file <- rv$files_names[cur_ind - 1]
    }
  })
  observeEvent(input$file_next,{
    req(rv$save)
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind < length(rv$files_names) ){
      # save metadata
      out <- saveAttribute(savevar, rv)
      savevar <- out$s
      rv <- out$r
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
      out <- saveAttribute(savevar, rv)
      savevar <- out$s
      rv <- out$r
      # change file
      rv$current_attribute <- rv$df_file$attributeName[cur_ind - 1]
    }
  })
  observeEvent(input$attribute_next,{
    req(rv$save)
    cur_ind <- match(rv$current_attribute,
                     rv$df_file$attributeName)
    if(cur_ind < length(rv$df_file$attributeName)){
      # save metadata
      out <- saveAttribute(savevar, rv)
      savevar <- out$s
      rv <- out$r
      # change file
      rv$current_attribute <- rv$df_file$attributeName[cur_ind + 1]
    }
    cat(rv$current_attribute,"\n")
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
  
  # Procedurals ----
  output$edit_template <- renderUI({
    # prepare variables
    row <- rv$df_file[rv$df_file[1] == rv$current_attribute,]
    unitList <- c("custom", get_unitList()$units$name)
    
    # actions
    tagList(
      # write each attribute's characteristic
      lapply(names(row), function(colname) {
        # prepare var
        input_id <- paste(rv$current_file,row["attributeName"],colname,sep = "_")
        
        # Servers ----
        rv$save[[colname]] <- reactive({
          enter <- switch (colname,
                         dateTimeFormatString = paste(input[[paste0(input_id,"_date")]],
                                                      ifelse(is.na(input[[paste0(input_id,"_hour")]]),
                                                             NULL,
                                                             input[[paste0(input_id,"_hour")]] 
                                                             )
                                                      ),
                         unit = paste(input[[input_id]],
                                      ifelse(is.na(input[[paste0(input_id, "_custom")]]),
                                             NULL,
                                             input[[paste0(input_id, "_custom")]] 
                                             )
                                      ),
                         input[[input_id]]
          )
          if(is.list(enter))
            enter <- unlist(enter)
          if(!isTruthy(enter)){
            enter <- ifelse(isTruthy(unlist(row[colname])),
                            unlist(row[colname]),
                            ""
            )
          }
          enter
        })
        
        # UIs ----
        switch(colname,
               # attributeName = h3(row[colname]),
               attributeDefinition = textAreaInput(ns(input_id),
                                                   "Describe the attribute concisely"),
               class = HTML(paste("<b>Detected class:</b>", as.vector(row[colname]) ) ),
               unit = if(grepl("!Add.*here!", row[colname]))
                 tagList(selectInput(ns(input_id), 
                                     span("Existing unit", style=redButtonStyle),
                                     unitList
                         ),
                         conditionalPanel(reactive({r2js.boolean(
                                            input[[ns(input_id)]] == "custom"
                                          ) })(), # js expression
                                          textInput(ns( paste0(input_id,"_custom") ),
                                                    span("Custom unit (ignored if not selected)",
                                                         style=redButtonStyle))
                         )
                 ),
               dateTimeFormatString = if(grepl("!Add.*here!",row[colname])){
                 tagList(selectInput(ns( paste0(input_id,"_date") ),
                                     span("Existing date format",
                                          style=redButtonStyle),
                                     DATE.FORMAT),
                         selectInput(ns( paste0(input_id,"_hour") ),
                                     "Existing hour format",
                                     HOUR.FORMAT)
                 )
               },
               missingValueCode = textInput(ns(input_id), "Code for missing value"),
               missingValueCodeExplanation = textAreaInput(ns(input_id), "Explain Missing Values")
        ) # end of switch
      }) # end of lapply colname
    ) # end of tagList
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
  observe({
    tmp_df <- rv$df_file[,c("attributeName","class","dateTimeFormatString","unit")]
    if(all(sapply(unlist(tmp_df), isTruthy)))
      rv$completed = TRUE
    else
      rv$completed = FALSE
  })
  # allow nexTab progression
  observe({
    if(rv$completed)
      enable(ns("nextTab"))
    else
      disable(ns("nextTab"))
  })
  
  # Output ----
  return(savevar)
}