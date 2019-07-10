# EMLAL_create.R

## 2. CREATE DATA PACKAGE
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
