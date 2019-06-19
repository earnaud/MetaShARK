# EMLAL_functions.R

### IMPORTS ###
library("tcltk2")

### UI OUTPUTS ###

## 0. SELECT DATA PACKAGE
createDPUI <- function(id, title, IM, testArgs){
  ns <- NS(id)
  
  return(
      fluidPage(
        div(
          p(
            paste("I received:", testArgs)
          )
        )
      ) # end fluidPage
    ) # end return
}

createDP <- function(input, output, session, IM){
  ns <- session$ns
  
}
