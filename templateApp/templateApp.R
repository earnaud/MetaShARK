### This script is for development purposes only. It shall not 
### be called in other part of the EML UI ShinyApp (current 
### directory).

### Lexica
# * fieldName: user-friendly name for the filled information
#     (e.g. 'fieldName' for the xml tag name)
# * xmlElement: technical name for the filled information
#     (= xml tag name)
# * 

library(shiny)

### functions ###

# display a row and shows its memorized value on the right
simpleInputRow <- function(fieldName,
                           xmlTag,
                           placeholder = NULL){
  splitLayout(
    textInput(inputId = xmlTag,
              paste(fieldName," (",xmlTag,")"),
              placeholder = placeholder),
    h4(textOutput(xmlTag))
  )
  
}

####### UI #######

xmlElements = c("gentleAndComprehensibleWord_1",
                "gentleAndComprehensibleWord_2")
xmlAttributes = c("technicalId_1",
                  "technicalId_2")
placeholders = paste("e.g.",
                     c("example_1",
                       "example_2"))

if(length(xmlElements) != length(xmlAttributes)
   || length(placeholders) != length(xmlAttributes)
   || length(xmlElements) != length(placeholders)) 
  stop("[Dev] xmlElements, xmlAttributes and placeholders length differ !")

ui <- fluidPage(
  splitLayout(
    h2("Enter information"),
    h2("Gathered information")
  ),
  
  lapply(1:length(xmlElements), 
         function(i){
           simpleInputRow(xmlElements[i],
                          xmlAttributes[i],
                          placeholders[i])
         }
  ),
  actionButton(style="position:absolute;left:1em;bottom:1em;",
               "main_menu", "Main menu"),
  actionButton(style = "position:absolute;right:1em;bottom:1em;",
               "proceed", "Proceed")
  
  
  
)

##### Server #####

server <- function(input,
                   output){

  # verbose function
  lapply(1:length(xmlElements), 
         function(i){
           attribute <- xmlAttributes[i]
           output[[attribute]] <- reactive({
             input[[attribute]]
           })
         })
  
}

#### LaunchApp ####

shinyApp(ui, server)