# fillWelcome.R

### IMPORTS ###
# source("modules/fill/welcome/fillWelcome_functions.R")



### UI ###
fillWelcomeUI <- function(id, IM){
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      box(textInput(ns("newProjectName"),"Name your project:"),
          div(id=ns("npButton"),actionButton(inputId = ns("newProjectButton"),
                                        label = "Create project",
                                        icon = icon("plus-square"))),
          width = 12, title = "New project")
    ),
    fluidRow(
      box(uiOutput(ns("existingProjects")),
          width = 12, title = "Open existing project")
    )
  )
}



fillWelcome <- function(input, output, session, IM){
  ns <- session$ns
  
  # observers
  observeEvent(input$newProjectName, {
    if(input$newProjectName == "")
      shinyjs::hide(id = "npButton", anim = TRUE, time = 0.25)
    else
      shinyjs::show(id = "npButton", anim = TRUE, time = 0.25)
  })
  
  output$existingProjects <- renderUI({
    ls.cache <- gsub(".cache/","",list.dirs(".cache/"))
    ls.cache <- ls.cache[ls.cache != ""]
    if(length(ls.cache) > 0)
      return(
        div(
          selectInput(ns("openProjectName"),
                      "Select the existing project's name",
                      choices = ls.cache),
          actionButton(inputId = ns("openProjectButton"),
                       label = "Open project",
                       icon = icon("sign-in-alt"))
        )
      )
    else
      return("You don't have any local project saved yet.")
  })
}

# UI switch function
fwDisplay <- function(input, output, session){
  
  default <- reactiveValues(clicked = FALSE)
  
  observeEvent({input$newProjectButton; input$openProjectButton}, {
    default$clicked <- TRUE
  })
  
  # display switch
  ui_rct <- eventReactive({input$newProjectButton; input$openProjectButton}, {
    print("click !")
    "open"
  })
  
  np_rct <- eventReactive(input$newProjectButton, {
    input$newProjectName
  })
  
  op_rct <- eventReactive(input$openProjectButton, {
    input$openProjectName
  })
  
  prct <- reactive({
    c(np_rct(), op_rct())[which(c(nchar(np_rct()), nchar(op_rct())) > 0)]
  })
  
  # output build
  return(list(ui = {
    ifelse(default$clicked, ui_rct(), "welcome")
  }))
  
  
  # return(list(ui_rct, prct))
  
}