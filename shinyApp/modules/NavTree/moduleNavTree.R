### moduleNavTree.R

# Imports
library(shinyTree)
source("functionsNavTree.R")
source("../../_infoBuilder/multiApply.R")

# Guidelines
cat("Loading Guidelines: \n")
cat("* Loading User Guideline ...\r")
UserGuideline = as.list(readRDS("../../guideLines/UserGuidelineList.RData"))
cat("* User Guideline successfully loaded !\n")
cat("* Loading System Guideline ...\r")
SystemGuideline = as.list(readRDS("../../guideLines/SystemGuidelineList.RData"))
cat("* System Guideline successfully loaded !\n")

# UI functions
navTreeUI <- function(id, IM){
  ns <- NS(id)

  # UI output
  tagList(
    sidebarPanel(
      shinyTree(outputId = ns(IM[2]),
                search = TRUE)
    ),
    mainPanel(
      "Currently Selected:",
      verbatimTextOutput(ns(IM[3]))
    )
  )

}



# Server functions
navTree <- function(input, output, session, IM, tree = UserGuideline){
  
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
      path <- gsub("^/","",
                  paste(
                    paste(attr(node[[1]], "ancestry"), collapse="/"),
                    unlist(node),
                    sep="/")
              )
      leaf <- followPath(tree, path)
      
      if(is.list(leaf))
        return(path)
      return(leaf)
    }
  })
  
}


