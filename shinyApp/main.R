# main.
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

### IMPORTS ###
library(shiny)
library(shinydashboard)

source("modules/documentation/documentation.R")

### RESOURCES ###

# IM: Id Modules - first: session - last: output id - others: intermediary id
IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
# IM.doc = c("fillModule", "Fill")

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
                        tabItem(tabName = "fill"),
                        tabItem(tabName = "documentation",
                                docUI(IM.doc[1], IM = IM.doc)),
                        tabItem(tabName = "about")
                      )
                    )
)

# ui <- fluidPage(
#   # Styling and other user-friendly settings
#   tags$head(
#     tags$style(
#       HTML("
#         pre {
#           white-space: pre-wrap;
#           word-break: keep-all;
#         }
#       ")
#     )
#   ),
#   tabsetPanel(
#     tabPanel("Fill", "Nothing yet"),
#     tabPanel("Documentation", )
#   )
# )

### SERVER ###
server <- function(input,output,session){
  session$onSessionEnded(stopApp)
  
  # modules called
  output <- callModule(documentation, IM.doc[1], IM = IM.doc)
  # callModule(fill, IM.fill[1], IM = IM.fill)
}

### APP LAUNCH ###
shinyApp(ui,server)