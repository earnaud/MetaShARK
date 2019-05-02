# main.
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

### IMPORTS ###
library(shiny)



### RESOURCES ###

# IM: Id Modules - first: session - last: output id - others: intermediary id
IM.navTree = c("navTreeModule", "navTree", "navTreeSelect","navPath","navSearch")

### UI ###
ui <- fluidPage(

    )
  ),
  tabsetPanel(
    tabPanel("Fill", "Nothing yet"),
    tabPanel("Documentation", navTreeUI(IM.navTree[1], IM = IM.navTree))
  )
)


}

### APP LAUNCH ###
shinyApp(ui,server)