# fill.R

### UI ###
fillUI <- function(id, IM){
  ns <- NS(id)
  
  tabsetPanel(id = ns("tabs"),
    tabPanel(IM.EMLAL[2], EMLALUI(IM.EMLAL[1], IM.EMLAL)),
    tabPanel("MetaFIN", h1("Under Construction"))
  )
  
}



### SERVER ###
fill <- function(input, output, session, IM){
  
}