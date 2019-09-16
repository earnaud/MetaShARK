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
    box(width = 4,
        title = "Authorship",
        HTML(
          "<p>The `EML Assembly Line` package used in this module
      and its children is the intellectual property of the
      Environment Data Initiative (EDI). You can find further
      details on their 
      <a href=https://github.com/EDIorg/EMLassemblyline>git repository</a>.</p>
      <img src=\"resources/pictures/EDI-logo.png\" 
           alt=\"EDI logo\" />"
        )
    ), # end authorship
    box(width = 8,
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
    ), # end how-to-use
    box(
<<<<<<< HEAD
      title = "EML Assembly Line",
      width = 12,
      uiOutput(ns("currentUI"))
    ) # end variable UI
  ) # end fluidPage

}

### SERVER ###
EMLAL <- function(input, output, session, IM, globalRV){
=======
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
    box(
      title = "EML Assembly Line",
      width = 12,
      uiOutput(ns("currentUI"))
    )
  )
}

### SERVER ###
EMLAL <- function(input, output, session, IM, nav){
>>>>>>> 3febdf2ca1a57bb74307fb0956183fd0ae27c724
  ns <- session$ns
  
  # variable initialization
  steps = paste0(c("select","create","template","edit","make","publish"), "-tab")
  
  # Output
  output$currentUI <- renderUI({
<<<<<<< HEAD
      switch(globalRV$navigate,
           `1` = selectDPUI(id = IM.EMLAL[3],
                            IM = IM.EMLAL,
                            title = steps[1]),
           `2` = createDPUI(id = IM.EMLAL[4],
=======
    print(as.character(nav$current))
    switch(as.character(nav$current),
           "1" = selectDPUI(id = IM.EMLAL[3],
                            IM = IM.EMLAL,
                            title = steps[1],
                            DP.path = DP.path),
           "2" = createDPUI(id = IM.EMLAL[4],
>>>>>>> 3febdf2ca1a57bb74307fb0956183fd0ae27c724
                            IM = IM.EMLAL,
                            title = steps[2]))
  })
  
}