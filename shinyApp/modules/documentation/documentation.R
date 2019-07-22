### documentation.R

### UI ###
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

### SERVER ###
documentation <- function(input, output, session, IM, tree = docGuideline, ns.index = nsIndex){
  
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
      out <- extractContent(systemContent, nsIndex = ns.index)
      return(out)
    }
  })
  
}


