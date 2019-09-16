# fill.R

### UI ###
fillUI <- function(id, IM){
  ns <- NS(id)
  
<<<<<<< HEAD
  h1("Under construction.")
  # tabsetPanel(id = ns("tabs"),
  #   tabPanel(IM.EMLAL[2], EMLALUI(IM.EMLAL[1], IM.EMLAL)),
  #   tabPanel("MetaFIN", h1("Under Construction"))
  # )
=======
  tabsetPanel(id = ns("tabs"),
    tabPanel("EML Assembly Line", h1("Under Construction")),
    # tabPanel(IM.EMLAL[2], EMLALUI(IM.EMLAL[1], IM.EMLAL)),
    tabPanel("MetaFIN", h1("Under Construction"))
  )
>>>>>>> 3febdf2ca1a57bb74307fb0956183fd0ae27c724
  
}



### SERVER ###
fill <- function(input, output, session, IM, globalRV){
  
  # variable initialization ----
  # save variable
  savevar <- initReactive()

  observeEvent(globalRV$navigate,{
    savevar$emlal$step <- max(
      globalRV$navigate,
      savevar$emlal$step
    )
  })
  
  return(savevar)
}