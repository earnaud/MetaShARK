# fill.R

### IMPORTS ###
library(EML)

source("modules/fill/EMLAL/EMLAL.R")

### RESOURCES ###
IM.EMLAL = c("EMLALModule","EML Assembly Line",
             "select","create","edit","make","publish")

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