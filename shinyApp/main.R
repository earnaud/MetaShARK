# main.
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

### IMPORTS ###
library(shiny)
library(shinydashboard)

source("modules/documentation/documentation.R")
source("modules/fill/fill.R")

### RESOURCES ###

# IM: Id Modules - first: session (=module namespace) - others: IDs
IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
IM.fill = c("fillModule", "Fill")

### UI ###
ui <- dashboardPage(dashboardHeader(title = "MetaShARK"),
                    ## Menus ##
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Generate EML", tabName = "generate", icon = icon("file")),
                        menuItem("Fill in EML", tabName = "fill", icon = icon("file-import")),
                        menuItem("EML Documentation", tabName = "documentation", icon = icon("glasses")),
                        menuItem("About MetaShARK", tabName = "about", icon = icon("beer"))
                      )
                    ),
                    ## Content ##
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "generate"),
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
  output$doc <- callModule(documentation, IM.doc[1], IM = IM.doc)
  output$fill <- callModule(fill, IM.fill[1], IM = IM.fill)
}

### APP LAUNCH ###
shinyApp(ui,server)