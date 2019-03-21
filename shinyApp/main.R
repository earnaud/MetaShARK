setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(shiny)

source("./templateApp/templateModule.R")
source("./templateMetadataInfo/parseMetadataInfo.R")

########## UI ##############

path="./templateMetadataInfo/templates/"
files = dir(path)
files = sapply(files, function(file){
  file = gsub("metadata","", file)
  file = gsub(".csv","",file)
  return(file)
})

# Build tabs UI elements contents
tabPanels = lapply(1:length(files), function(file){
  tabPanel(files[file],
           sidebarPanel(
             "Insert tree for user here !"
           ),
           mainPanel(
             inputUi(files[file],
                     metadataFields = parseMetadataInfo(files[file])))
           )
})
# UI itself
ui <- shinyUI(
  navbarPage(
    "EML Manager",
    do.call(navbarMenu,
            c("Fill information file", tabPanels)
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
  output <- lapply(files, 
                   function(file){
                    callModule(inputServer,file, 
                    xmlName = parseMetadataInfo(file)$xmlName)
                  })
}

####### Launch App ###########
shinyApp(ui=ui, server=server)