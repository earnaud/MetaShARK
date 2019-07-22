# EMLAL.R

# Derived Id Modules from IM.EMLAL by pasting the step number (https://ediorg.github.io/EMLassemblyline/articles/overview.html)

### UI ###
EMLALUI <- function(id, IM){
  ns <- NS(id)
  
  steps = list(`Organize data package` = 1,
               `Create metadata templates` = 2,
               `Edit metadata templates` = 3,
               `Make EML` = 4)
  step = steps[[1]]
  
  fluidPage(
    style="padding-top:2.5%;",
    box(
      title = "Authorship",
      HTML(
        "<p>The `EML Assembly Line` package used in this module
        and its children is the intellectual property of the
        Environment Data Initiative (EDI). You can find further
        details on their 
        <a href=https://github.com/EDIorg/EMLassemblyline>git repository</a>.</p>
        <img src=\"resources/pictures/EDI-logo.png\" 
             alt=\"EDI logo\"
             style=\"width:100px; height:100px\" />"
      )
    ),
    box(
      title = "How to use",
      HTML(
        "<p><b>EMLassemblyline</b> is a metadata builder for scientists
        and data managers who need to easily create high quality 
        <b>EML</b> metadata for data publication. It emphasizes 
        auto-extraction of metadata, appends value added content, 
        and accepts user supplied inputs through template files 
        thereby minimizing user effort while maximizing the potential
        of future data discovery and reuse. EMLassemblyline requires 
        no familiarity with EML, is great for managing 10-100s of 
        data packages, accepts all data formats, and supports complex
        and fully reproducible science workflows. Furthermore, it 
        incorporates <a href=\"https://environmentaldatainitiative.files.wordpress.com/2017/11/emlbestpractices-v3.pdf\">EML best practices</a>,
        is based on a simple file organization scheme, and is not tied to a specific data repository.</p>
        <i>(preface by Colin Smith, EDI)</i>"
      )
    ),
    tabBox(
      title = "EML Assembly Line",
      id = ns("main"),
      side = "left", width = 12,
      tabPanel(
        value = "select-tab",
        title = icon("plus-circle"),
        uiOutput(ns("EMLALUI.select"))
      ),
      tabPanel(
        value = "create-tab",
        title = icon("arrow-alt-circle-right"),
        uiOutput(ns("EMLALUI.create"))
      )
    )
  )
}

### SERVER ###
EMLAL <- function(input, output, session, IM){
  ns <- session$ns
  
  # reactive values
  steps = paste0(c("select","create","edit","make","publish"), "-tab")
  
  # Output
  output$EMLALUI.select <- renderUI({ selectDPUI(id = IM.EMLAL[3],
                                                 IM = IM.EMLAL,
                                                 title = steps[1],
                                                 DP.path = DP.path)
                            })
  output$EMLALUI.create <- renderUI({ createDPUI(id = IM.EMLAL[4],
                                                 IM = IM.EMLAL,
                                                 title = steps[2],
                                                 testArgs = "testArgs")
                           })
}
