# documentation.R

### IMPORTS ###



### UI ###
fill.UI <- function(id, IM){
  ns <- NS(id)
  
  pageWithSidebar(
    sidebarPanel("Terms"),
    mainPanel("Input form")
  )
}



### SERVER ###
fill <- function(input, output, session, IM){
  
}