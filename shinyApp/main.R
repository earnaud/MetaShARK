# main.R
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
options(shiny.reactlog=TRUE)



### IMPORTS ###
library(shiny)
library(shinydashboard)
library("shinyjs")

source("modules/about/about.R")
source("modules/documentation/documentation.R")
source("modules/fill/fill.R")
source("modules/welcome/welcome.R")

if(!dir.exists(".cache/")) dir.create(".cache/")

### RESOURCES ###

# IM: Id Modules - first: session (=module namespace) - others: IDs
IM.about = c("aboutModule", "About")
IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
IM.fill = c("fillModule", "Fill")
IM.welcome = c("welcomeModule", "Welcome")

# CSS var
menuWidth = "250px"


### UI ###
ui <- dashboardPage(dashboardHeader(title = span(imageOutput("logo", inline = TRUE), "MetaShARK")
                                    ,titleWidth = menuWidth
                                    ),
                    ## Menus ##
                    dashboardSidebar(
                      useShinyjs(),
                      sidebarMenu(
                        menuItem("Welcome", tabName = "welcome", icon = icon("home")),
                        menuItem("Fill in EML", tabName = "fill", icon = icon("file-import")),
                        menuItem("EML Documentation", tabName = "documentation", icon = icon("glasses")),
                        menuItem("About MetaShARK", tabName = "about", icon = icon("beer"))
                      )
                      ,width = menuWidth
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
                        tabItem(tabName = "about",
                                aboutUI(IM.about[1], IM = IM.about))
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
      fill.emlal.selectDP <- callModule(selectDP, IM.EMLAL[1], IM = IM.EMLAL, DP.path = DP.path)
      fill.emlal.createDP <- callModule(createDP, IM.EMLAL[1], IM = IM.EMLAL)
  # doc
  doc <- callModule(documentation, IM.doc[1], IM = IM.doc)
  
  ## Common UI elements
  output$logo <- renderImage({ list(src = "resources/pictures/MetaShARK_icon2.png",
                                    contentType = "image/png",
                                    width = "100px",
                                    height = "50px") }, deleteFile = FALSE)
}

### APP LAUNCH ###
shinyApp(ui, server)
