### documentation.R

# Imports
library(shinyTree)
source("modules/documentation/documentation_functions.R")
source("modules/documentation/documentation_style.R")
source("utils/multiApply.R")

# Guidelines
cat("Loading Guidelines: \n")

cat("* Loading Doc Guideline ...\r")
docGuideline = as.list(readRDS("resources/docGuideline.RData"))
cat("* Doc Guideline successfully loaded !\n")

cat("* Loading System Guideline ...\r")
systemGuideline = as.list(readRDS("resources/systemGuideline.RData"))
cat("* System Guideline successfully loaded !\n")

cat("Loading Namespaces Index ...\r")
nsIndex = readRDS("resources/nsIndex.RData")
cat("Namespaces Index successfully loaded !\n")


# UI functions
docUI <- function(id, IM){
  ns <- NS(id)
  
  # UI output
  fluidRow(
    # search sidebar
    column(4,
           box(shinyTree(outputId = ns(IM[2]), # render tree
                         search = TRUE),
               width = 12
           )
           , style = sidebarStyle
    ),
    # display main panel
    column(8,
           div(box(uiOutput( ns(IM[4]) ), # XPath
                   uiOutput( ns(IM[3]) ), # Documentation
                   width = 12
               )
               , style = mainpanelStyle
           )
    )
  )
}



# Server functions
documentation <- function(input, output, session, IM, nsIndex = nsIndex, tree = docGuideline){
  
  # render tree
  output[[IM[2]]] <- renderTree(tree)
  
  # output selected node
  output[[IM[3]]] <- renderText({
    jstree <- input[[IM[2]]]
    if (is.null(jstree)){
      "None"
    } else{
      node <- get_selected(tree = jstree)
      if(length(node) == 0)
        return("(Select a node first)")
      docPath <- gsub("^/","",
                       paste(
                         paste(attr(node[[1]], "ancestry"), collapse="/"),
                         unlist(node),
                         sep="/")
      )
      output[[IM[4]]] <- renderText(as.character(h3(docPath)))
      
      # fetch the systemGuideLine path in the userGuideLine list
      systemPath <- followPath(tree, docPath)
      
      if(!is.character(systemPath))
        systemPath <- commonPath(systemPath,unlist(node))
      # return(userPath)
      
      # fetch the eml-xsd content in the systemGuideLine list
      systemContent <- followPath(systemGuideline, systemPath)
      out <- extractContent(systemContent, nsIndex)
      return(out)
    }
  })
  
}


