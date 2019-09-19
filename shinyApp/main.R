# main.R
source("header.R")

### UI
ui <- dashboardPage(
  title = "MetaShARK",
  dashboardHeader(
    title = span(imageOutput("logo", inline = TRUE), "MetaShARK"),
    titleWidth = menuWidth
  ),
  ## Menus ----
  dashboardSidebar(
    useShinyjs(), 
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", 
               icon = icon("home")),
      menuItem("Fill in EML", tabName = "fill", 
               icon = icon("file-import")),
      menuItem("EML Documentation", tabName = "documentation", 
               icon = icon("glasses")),
      menuItem("About MetaShARK", tabName = "about", 
               icon = icon("beer"))
      ,actionButton("check","Dev Check")
    ),
    width = menuWidth
  ), # end sidebar
  ## Content ----
  dashboardBody(
    tabItems(
      tabItem(tabName = "welcome",
              welcomeUI(IM.welcome[1], IM = IM.welcome)),
      tabItem(tabName = "fill",
              fillUI(IM.fill[1], IM = IM.fill)),
      tabItem(tabName = "documentation",
              docUI(IM.doc[1], IM = IM.doc)),
      tabItem(tabName = "about",
              aboutUI(IM.about[1], IM = IM.about))
    )
  ) # end body
) # end dashboard



### SERVER
server <- function(input,output,session){
  session$onSessionEnded(function() rm(list=ls()))
  session$onSessionEnded(stopApp)
  
  # Reactive values ----
  globalRV <- reactiveValues(
    navigate =  1,
    previous = "select"
  )
  # the saved metadata will be saved through modules output `fill`
  # DEV: do things by clicking a button
  observeEvent(input$check,{
    browser()
  })
  observe({
    if(is.null(globalRV$navigate) || is.null(savevar))
      browser()
  })
  
  ## modules called ----
  # welcome
  welcome <- callModule(welcome, IM.welcome[1], IM = IM.welcome)
  # fill
  savevar <- callModule(fill, 
                     IM.fill[1], 
                     IM = IM.fill,
                     globalRV = globalRV)
    callModule(EMLAL, 
               IM.EMLAL[1], 
               IM = IM.EMLAL,
               globalRV = globalRV)
    savevar <-
      callModule(selectDP, 
                 IM.EMLAL[3], 
                 IM = IM.EMLAL, 
                 DP.path = DP.PATH,
                 savevar = savevar,
                 globalRV = globalRV)
    savevar <-
      callModule(createDP, 
                 IM.EMLAL[4], 
                 IM = IM.EMLAL,
                 savevar = savevar,
                 globalRV = globalRV)
    savevar <-
      callModule(templateDP, 
                 IM.EMLAL[5], 
                 IM = IM.EMLAL,
                 savevar = savevar,
                 globalRV = globalRV)
  
  # doc
  doc <- callModule(documentation, 
                    IM.doc[1], 
                    IM = IM.doc)
  
  # about
  about <- callModule(about,
                      IM.about[1],
                      IM = IM.about,
                      bibliography)
  
  ## Common UI elements ----
  # MetaShARK logo
  output$logo <- renderImage({
    list(src="resources/pictures/MetaShARK_icon2.png",
         contentType = "image/png",
         width = "100px",
         height = "50px") 
    },
    deleteFile = FALSE
  )
  
  # called in modules/fill/EMLAL.R
  output$`edi-logo` <- renderImage({
    
    # square dimensions
    side = session$clientData$`output_edi-logo_width`
    
    # write temp file
    outfile <- "resources/pictures/EDI-logo.png"
    png(outfile, width=side, height=side)
    dev.off()
    
    list(src=outfile,
         contentType = "image/png",
         width = side,
         height = side # square
         )
  },
  deleteFile = FALSE)
}

### APP LAUNCH
shinyApp(ui, server)

