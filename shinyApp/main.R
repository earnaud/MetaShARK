# main.R
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

### IMPORTS ###
library(shiny)
library(shinydashboard)
library("shinyjs")

source("modules/documentation/documentation.R")
source("modules/fill/fill.R")

if(!dir.exists(".cache/")) dir.create(".cache/")

### RESOURCES ###

# IM: Id Modules - first: session (=module namespace) - others: IDs
IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
IM.fill = c("fillModule", "Fill")

### UI ###
ui <- dashboardPage(dashboardHeader(title = "MetaShARK"),
                    ## Menus ##
                    dashboardSidebar(
                      useShinyjs(),
                      sidebarMenu(
                        menuItem("Welcome", tabName = "welcome", icon = icon("home")),
                        menuItem("Fill in EML", tabName = "fill", icon = icon("file-import")),
                        menuItem("EML Documentation", tabName = "documentation", icon = icon("glasses")),
                        menuItem("About MetaShARK", tabName = "about", icon = icon("beer"))
                      )
                    ),
                    ## Content ##
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "welcome"),
                        tabItem(tabName = "fill",
                                fillUI(IM.fill[1], IM = IM.fill)),
                        tabItem(tabName = "documentation",
                                docUI(IM.doc[1], IM = IM.doc)),
                        tabItem(tabName = "about")
                      )
                    )
)



### SERVER ###
server <- function(input,output,session){
  session$onSessionEnded(stopApp)
  
  # modules called
  doc <- callModule(documentation, IM.doc[1], IM = IM.doc)
  fill <- callModule(fill, IM.fill[1], IM = IM.fill)
    fillWelcome <- callModule(fillWelcome, IM.welcome[1], IM = IM.welcome)
}

### APP LAUNCH ###
shinyApp(ui,server)