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

# inputUI frame for input information concerning inputs
# inputs:
# - id: for modularization purposes
# - ufName: user-friendly synonym of xmlElement
# - xmlName: dev-friendly name of xmlElement
# - placeholder: example of input
# - required: vector ofindicating whether the field shall be filled or not
# OR
# - metadataFields: table of (ufName,xmlName,placeholder,required)
inputUi <- function(id="test",
                    ufName = "Gentle Name", 
                    xmlName = "gentleTag",
                    placeholders,
                    required,
                    metadataFields = c("Gentle Name", "gentleTag")){
  
  # required by modularization: create a namespace
  ns <- NS(id)
  
  # Acquire arguments by a way or another
  if(is.null(ufName) && is.null(xmlName) && is.null(metadataFields))
    stop("No fields are input !")
  if(!(is.null(metadataFields))){
    ufName = metadataFields$ufName
    xmlName = metadataFields$xmlName
    if(length(metadataFields$placeholder) != 0)
      placeholders = metadataFields$placeholder
    required = metadataFields$required
  }
  
  
  # Check arguments integrity
  if(length(ufName) != length(xmlName))
    stop("[Dev] ufName, xmlName length differ !")
  if(length(placeholders) > 0 && length(placeholders) != length(ufName)){
    warning("Not enough placeholders: replaced by a NULL vector")
    placeholders <- NULL
  }
  
  # UI graphical display
  tagList(
    splitLayout(
      h2("Enter information"),
      h2("Current state")
    ),
    
    lapply(1:length(ufName), 
           function(i){
             if(i%%2!=0) bg = TRUE
             if(i%%2==0) bg = FALSE
             simpleInputRow(id=id,
                            ns(ufName[i]),
                            ns(xmlName[i]),
                            ns(placeholders[i]),
                            bg)
           }
    )
  )
}

##### Server #####

inputServer <- function(input,output, session, xmlName){
  
  # verbose function
  lapply(1:length(xmlName),
         function(i){
           attribute <- xmlName[i]
           output[[attribute]] <- reactive({
             input[[attribute]]
           })
         })
  
  return(output)
}