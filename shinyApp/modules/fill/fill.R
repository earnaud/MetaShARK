# fill.R

### IMPORTS ###
cat("* Loading Fill Guidelines: \n")
fillGuideline = as.list(readRDS("resources/fillGuideline.RData"))
cat("** Fill Guideline successfully loaded !\n")

### UI ###
fillUI <- function(id, IM){
  ns <- NS(id)
  
  fluidPage(
    h1("under construction")
  )
  
}



### SERVER ###
fill <- function(input, output, session, IM){
  ns <- session$ns
  
}