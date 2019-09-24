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
                )
               )
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
             ,actionButton("check2","Dev Check")
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
    # local
    location = c(),
    files_names = c(),
    current_file = c(),
    current_attribute = c()
  )
  observe({
    if(!identical(savevar, initReactive())){
      rv$location <- paste0(savevar$emlal$selectDP$dp_path,"/",
                            savevar$emlal$selectDP$dp_name)
      rv$files_names <- savevar$emlal$createDP$dp_data_files$name
      rv$current_file <- rv$files_names[1]
    }
  })
  # [OPTI] ----
  # inputs
  # -- files
  observeEvent(input$file_prev,{
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind > 1)
      rv$current_file <- rv$files_names[cur_ind - 1]
  })
  observeEvent(input$file_next,{
    cur_ind <- match(rv$current_file, rv$files_names)
    if(cur_ind < length(rv$files_names) )
      rv$current_file <- rv$files_names[cur_ind + 1]
  })
  # -- attribute
  observeEvent(input$attribute_prev,{
    cur_ind <- match(row.names(rv$current_attribute),
                     row.names(rv$df_file))
    if(cur_ind > 1)
      rv$current_attribute <- rv$df_file[cur_ind - 1,"attributeName"]
  })
  observeEvent(input$attribute_next,{
    cur_ind <- match(rv$current_attribute,
                     row.names(rv$df_file))
    if(cur_ind < length(row.names(rv$df_file)))
      rv$current_attribute <- rv$df_file[cur_ind + 1,"attributeName"]
  })
  
  # process
  # -- files
  observe({
    req(rv$current_file,
        savevar$emlal$createDP$dp_data_files$metadatapath)
    toRead <- savevar$emlal$createDP$dp_data_files
    toRead <- toRead$metadatapath[match(rv$current_file,toRead$name)]
    # browser()
    rv$df_file <- fread(toRead, data.table = FALSE)
    rv$current_attribute <- rv$df_file[1,"attributeName"]
  })
  
  # -- attribute
  
  # outputs
  output$current_file <- renderUI(div(rv$current_file,
                                      style = "display: inline-block;
                                              font-size:20pt;
                                              text-align:center;
                                              width:70%;"
                                      ))
  output$current_attribute <- renderUI(div(rv$current_attribute,
                                           style = "display: inline-block;
                                                  font-size:15pt;
                                                  text-align:center;
                                                  width:70%;"
                                           ))
  output$attribute_table_TMP <- renderTable( rv$current_attribute )
  
  
  # # Produce fill template UI ----
  # output$fill_template <- renderUI({
  #   # load paths
  #   files <- isolate(rv$files_names)
  #   
  #   # read tables
  #   sapply(files, function(file){
  #     file <- tools::file_path_sans_ext(file)
  #     # save structure
  #     rv[[file]] <- list()
  #     
  #     filepath <- paste0(isolate(rv$location),
  #                        "/metadata_templates/attributes_",
  #                        file,
  #                        ".txt")
  #     DT <- fread(filepath)
  #     
  #     # UI output
  #     tagList(
  #       h2(file),
  #       # read each table attribute
  #       apply(DT, 1, function(row){
  #         # UI output
  #         tagList(
  #           # write each attribute's characteristic
  #           lapply(names(row), function(colname) {
  #             # prepare var
  #             input_id <- paste(file,row["attributeName"],colname,sep = "_")
  #             unitList <- c("custom",get_unitList()$units$name)
  #             
  #             # UI output
  #             switch(colname,
  #                    attributeName = h3(row[colname]),
  #                    attributeDefinition = textAreaInput(input_id,
  #                                                        "Describe the attribute concisely"),
  #                    class = HTML("Detected class:",row[colname]),
  #                    unit = if(grepl("!Add.*here!",row[colname]))
  #                             tagList(selectInput(input_id, "Existing unit", unitList),
  #                                     conditionalPanel(paste0("input.",input_id," == 'custom'"), # js expression
  #                                                      textInput(paste(input_id,"_custom"),
  #                                                                span("Custom unit",
  #                                                                     style=redButtonStyle))
  #                                                      )
  #                                     ),
  #                    dateTimeFormatString = if(grepl("!Add.*here!",row[colname])){
  #                                              tagList(selectInput(paste0(input_id,"_date"),
  #                                                                  span("Existing date format (mandatory)",
  #                                                                       style=redButtonStyle),
  #                                                                  DATE.FORMAT),
  #                                                      selectInput(paste0(input_id,"_hour"), 
  #                                                                  "Existing hour format (facultative)", 
  #                                                                  HOUR.FORMAT)
  #                                                      )
  #                                           },
  #                    missingValueCode = textInput(input_id, "Code for missing value"),
  #                    missingValueCodeExplanation = textAreaInput(input_id, "Explain Missing Values")
  #             ) # end of switch
  #           }) # end of lapply colname
  #         ) # end of tagList
  #       }) # end of apply row
  #     ) # end of tagList
  #   }) # end of sapply files
  # }) # end of renderUI
  # 
  # # Related server part
  # # observe({
  #   # load paths
  #   files <- tools::file_path_sans_ext(isolate(rv$files_names))
  #   # read tables
  #   sapply(files, function(file){
  #     # save structure
  #     rv[[file]] <- list()
  # 
  #     filepath <- paste0(isolate(rv$location),
  #                        "/metadata_templates/attributes_",
  #                        file,
  #                        ".txt")
  #     DT <- fread(filepath)
  #     # read each table attribute
  #     apply(DT, 1, function(row){
  #     # write each attribute's characteristic
  #     lapply(names(row), function(colname) {
  #       # prepare var
  #       input_id <- paste(file,row["attributeName"],colname,sep = "_")
  #       observe({
  #         # save inputs
  #         rv[[file]][[row["attributeName"]]] <- 
  #           if(colname == "dateTimeFormatString")
  #             list(date = input[[paste0(input_id,"_date")]],
  #                  hour = input[[paste0(input_id,"_hour")]])
  #           else if(colname == "unit"){
  #             if(!is.null(input[[input_id]])
  #                && input[[input_id]] == 'custom')
  #               input[[paste0(input_id, "_custom")]]
  #             else
  #               input[[input_id]]
  #           } else
  #             input[[input_id]]
  #       }) # alt end of observe
  #     }) # end of lapply COL
  #   }) # end of apply ROW
  # }) # end of sapply FILE
  # # }) # end of observe
  # 
  
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