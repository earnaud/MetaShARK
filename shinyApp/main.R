setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(shiny)

source("./templateApp/templateModule.R")
source("./templateMetadataInfo/parseMetadataInfo.R")

########## UI ##############

ui <- fluidPage(
  # titlePanel("EML Manager"),
  navbarPage(
    "EML Manager",
    navbarMenu("Fill information file",
      tabPanel("Personnel",
        inputUi("Personnel", metadataFields = parseMetadataInfo("Personnel"))
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
  output <- callModule(inputServer,"Personnel", 
                       xmlName = parseMetadataInfo("Personnel")$xmlName)
}

####### Launch App ###########
shinyApp(ui=ui, server=server)