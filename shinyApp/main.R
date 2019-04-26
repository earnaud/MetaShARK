# main.
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
### IMPORTS ###
library(shiny)

source("modules/NavTree/moduleNavTree.R", chdir = TRUE)

### RESOURCES ###

# IM: Id Modules - first: session - last: output id - others: intermediary id
IM.navTree = c("navTreeModule", "navTree", "navTreeSelect","navPath")

### UI ###
ui <- fluidPage(
  # Styling and other user-friendly settings
  tags$head(
    tags$style(
      HTML("
           pre {
              white-space: pre-wrap;
              word-break: keep-all;
           }
           ")
    )
  ),
  
    navTreeUI(IM.navTree[1], IM = IM.navTree)
)

### SERVER ###
server <- function(input,output,session){
  session$onSessionEnded(stopApp)
  
  # modules called
  output <- callModule(navTree, IM.navTree[1], IM = IM.navTree)
  
}

### APP LAUNCH ###
shinyApp(ui,server)