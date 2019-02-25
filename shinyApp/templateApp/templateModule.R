### shinyApp/templateApp
### functions file to be used as interface between input and save

### functions ###

# display a row and shows its memorized value on the right
simpleInputRow <- function(id,
                           fieldName,
                           xmlTag,
                           placeholder = NULL,
                           bg){
  
  # Due to modularization, the ID appears in the field and makes it
  # less easy to read
  
  {
    # label formatting
    label = paste(
      unlist(strsplit(fieldName,"-"))[2],
      "(",
      unlist(strsplit(xmlTag,"-"))[2],
      ")"
    )

    # placeholder formatting
    if(!is.null(placeholder))
      placeholder = unlist(strsplit(placeholder,"-"))[2]
    else
      placeholder = NULL
  }
  
  # misc
  if(bg) col = "#f5f5f5"
  if(!bg)col = "white"
  
  # Input itself
  splitLayout(style=paste("background-color:",col,";"),
    textInput(inputId = xmlTag,
              label,
              # paste(fieldName,xmlTag),
              placeholder = placeholder),
    h4(textOutput(xmlTag))

  )
  
}

####### UI #######
inputUi <- function(id, xmlElements, xmlAttributes, placeholders){
  
  # required by modularization: create a namespace
  ns <- NS(id)
  
  
  if(length(xmlElements) != length(xmlAttributes))
    stop("[Dev] xmlElements, xmlAttributes length differ !")
  if(length(placeholders) > 0 && length(placeholders) != length(xmlElements)){
    warning("Not enough placeholders: replaced by a NULL vector")
    placeholders <- NULL
  }
  
  tagList(
    splitLayout(
      h2("Enter information"),
      h2("Current state")
    ),
  
    lapply(1:length(xmlElements), 
           function(i){
             if(i%%2!=0) bg = TRUE
             if(i%%2==0) bg = FALSE
             simpleInputRow(id=id,
                            ns(xmlElements[i]),
                            ns(xmlAttributes[i]),
                            ns(placeholders[i]),
                            bg)
           }
    )
  )
}

##### Server #####

inputServer <- function(input,output, session, xmlAttributes){
  
  # verbose function
  lapply(1:length(xmlAttributes),
         function(i){
           attribute <- xmlAttributes[i]
           output[[attribute]] <- reactive({
             input[[attribute]]
           })
         })
  
  return(output)
}