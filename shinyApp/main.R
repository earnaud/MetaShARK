setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(shiny)

source("templateApp/templateModule.R")

########## UI ##############

ui <- fluidPage(
  # titlePanel("EML Manager"),
  navbarPage(
    "EML Manager",
    navbarMenu("Fill information file",
      tabPanel("Input_1",
        inputUi("input",c("nom_1","nom_2"),c("tag_1","tag_2"),c("thierry","joël"))
      )
    ),
    tabPanel("Generate EML file"
      # run make_eml
    ),
    navbarMenu("Be helped",
      tabPanel("EML format specifications"
        # display help and "how to fill information"
      )
    )
  )
)

######### Server #############

server <- function(input, output, session){
  output <- callModule(inputServer,"input", c("tag_1","tag_2"))
}

####### Launch App ###########
shinyApp(ui=ui, server=server)