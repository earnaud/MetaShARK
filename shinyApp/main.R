# main.R
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
options(shiny.reactlog=TRUE)



### IMPORTS ###
library(shiny)
library(shinydashboard)
library("shinyjs")

source("modules/documentation/documentation.R")
source("modules/fill/fill.R")
source("modules/welcome/welcome.R")

if(!dir.exists(".cache/")) dir.create(".cache/")

### RESOURCES ###
ns.index <- readRDS("resources/nsIndex.RData")

# IM: Id Modules - first: session (=module namespace) - others: IDs
IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
IM.fill = c("fillModule", "Fill")
IM.welcome = c("welcomeModule", "Welcome")

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
                        tabItem(tabName = "welcome",
                                welcomeUI(IM.welcome[1], IM = IM.welcome)),
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
  
  ## modules called
  # welcome
  welcome <- callModule(welcome, IM.welcome[1], IM = IM.welcome)
  # fill
  fill <- callModule(fill, IM.fill[1], IM = IM.fill)
  fill.emlal <- callModule(EMLAL, IM.EMLAL[1], IM = IM.EMLAL)
  # doc
  doc <- callModule(documentation, IM.doc[1], IM = IM.doc)
}

### APP LAUNCH ###
shinyApp(ui, server)
