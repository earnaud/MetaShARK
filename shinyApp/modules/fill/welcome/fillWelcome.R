# fillWelcome.R

### IMPORTS ###
# source("modules/fill/welcome/fillWelcome_functions.R")



### UI ###
fillWelcomeUI <- function(id, IM){
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      box(textInput(ns("newProjectName"),"Name your project:"),
          div(id=ns("np1"),actionButton(inputId = ns("openProject"),
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
      shinyjs::hide(id = "np1", anim = TRUE, time = 0.25)
    else
      shinyjs::show(id = "np1", anim = TRUE, time = 0.25)
  })
  
  # Output
  output$existingProjects <- renderUI({
    ls.cache <- gsub(".cache/","",list.dirs(".cache/"))
    ls.cache <- ls.cache[ls.cache != ""]
    if(length(ls.cache) > 0)
      return(
        div(
          selectInput(ns("project"),
                      "Select the existing project's name",
                      choices = ls.cache),
          actionButton(inputId = ns("openProject"),
                       label = "Open project",
                       icon = icon("sign-in-alt"))
        )
      )
    else
      return("You don't have any local project saved yet.")
  })
  
}