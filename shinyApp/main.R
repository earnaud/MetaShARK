# main.R
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

### IMPORTS ###
library(shiny)

source("modules/NavTree/moduleNavTree.R", chdir = TRUE)

### RESOURCES ###

# IM: Id Modules - first: session - last: output id - others: intermediary id
IM.navTree = c("navTreeModule", "navTree", "navTreeSelect")

### UI ###
ui <- fluidPage(
    navTreeUI(IM.navTree[1], IM = IM.navTree)
)

### SERVER ###
server <- function(input,output,session){
  
  # modules called
  output <- callModule(navTree, IM.navTree[1], IM = IM.navTree)
  
}

### APP LAUNCH ###
shinyApp(ui,server)