# header.R
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
options(shiny.reactlog=TRUE)

<<<<<<< HEAD
### RESOURCES ###

  ## Guidelines ----
    message("Loading Guidelines:")
    
    # Doc = Doc-only EML subspec
      docGuideline = as.list(readRDS("resources/docGuideline.RData"))
      message("* Doc Guideline successfully loaded !")
    
    # System = whole EML spec
      systemGuideline = as.list(readRDS("resources/systemGuideline.RData"))
      message("* System Guideline successfully loaded !")
      
    # Namespace Index = which namespace lead to what module
      cat("* Loading Namespaces Index ...\r")
      nsIndex <- readRDS("resources/nsIndex.RData")
      message("* Namespaces Index successfully loaded !")
    
    # Id Module ----
      IM.about = c("aboutModule", "About")
      IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
      IM.fill = c("fillModule", "Fill")
      IM.EMLAL = c("EMLALModule","EML Assembly Line",
                   "select","create","edit","make","publish")
      IM.welcome = c("welcomeModule", "Welcome")
  
  ## CSS var ----
    menuWidth = "250px"
    
    sidebarStyle = "overflow-y: scroll;
                      max-height: 800px;"
    
    mainpanelStyle = "overflow-y: scroll;
                      max-height: 800px;"
    
    inputStyle = "border: 1px solid lightgrey;
                    margin: 5px;
                    padding: 5px;
                    width: 100%;"
    
    redButtonStyle = "color: red;"
    
    rightButtonStyle = "position: right;
                          width: 100%;"
  
  ## Global variables ----
    DP.PATH <- paste0(getwd(),"/dataPackagesOutput/emlAssemblyLine/")
    THRESHOLD = list(
      dp_data_files = 500000
    )
    HOME = fs::path_home()

=======
>>>>>>> 3febdf2ca1a57bb74307fb0956183fd0ae27c724
### IMPORTS ----

  ## Libraries ----
  # GUI
    library(shiny)
    library(shinyTree)
    library(shinydashboard)
<<<<<<< HEAD
    library(shinyFiles)
    library(shinyjs)
    library(tcltk2)
    library(tippy) # install from github
=======
    library(shinyjs)
    library(tcltk2)
>>>>>>> 3febdf2ca1a57bb74307fb0956183fd0ae27c724
  
  # EML
    library(EML)
    library(EMLassemblyline)
    
  # Utils
    library(devtools)

  ## Modules assembly ----
  # Welcome
    source("modules/welcome/welcome.R")
  # Fill
    source("modules/fill/fill.R")
    source("modules/fill/input_templates.R")
      source("modules/fill/EMLAL/EMLAL.R")
      source("modules/fill/EMLAL/EMLAL_functions.R")
        source("modules/fill/EMLAL/EMLAL_selectDP.R")
        source("modules/fill/EMLAL/EMLAL_createDP.R")
  # Documentation
    source("modules/documentation/documentation.R")
      source("modules/documentation/documentation_functions.R")
      source("modules/documentation/documentation_style.R")
  # About
    source("modules/about/about.R")
  # Utils - not GUI
    source("utils/multiApply.R")
    source("utils/reactiveTrigger.R")
  
  ## Dir creation ----
    dir.create(".cache/", recursive = TRUE, showWarnings = FALSE)
<<<<<<< HEAD
    dir.create(DP.PATH, recursive = TRUE, showWarnings = FALSE)

### MISC ZONE ----
# Tippy real examples
# https://cran.r-project.org/web/packages/tippy/readme/README.html
=======
    DP.path <- paste0(getwd(),"/dataPackagesOutput/emlAssemblyLine/")
    dir.create(DP.path, recursive = TRUE, showWarnings = FALSE)

### RESOURCES ###

  ## Guidelines ----
    cat("Loading Guidelines: \n")
  
    # Doc = Doc-only EML subspec
      cat("* Loading Doc Guideline ...\r")
      docGuideline = as.list(readRDS("resources/docGuideline.RData"))
      cat("* Doc Guideline successfully loaded !\n")
    
    # System = whole EML spec
      cat("* Loading System Guideline ...\r")
      systemGuideline = as.list(readRDS("resources/systemGuideline.RData"))
      cat("* System Guideline successfully loaded !\n")
    
    # Namespace Index = which namespace lead to what module
      cat("* Loading Namespaces Index ...\r")
      nsIndex <- readRDS("resources/nsIndex.RData")
      cat("* Namespaces Index successfully loaded !\n")

  # Id Module ----
  IM.about = c("aboutModule", "About")
  IM.doc = c("docModule", "Documentation", "docSelect","docPath","docSearch")
  IM.fill = c("fillModule", "Fill")
  IM.EMLAL = c("EMLALModule","EML Assembly Line",
               "select","create","edit","make","publish")
  IM.welcome = c("welcomeModule", "Welcome")

  ## CSS var ----
  menuWidth = "250px"
  
  sidebarStyle = "overflow-y: scroll;
                  max-height: 800px;"
  
  mainpanelStyle = "overflow-y: scroll;
                  max-height: 800px;"
  
  inputStyle = "border: 1px solid lightgrey;
                margin: 5px;
                padding: 5px;
                width: 100%;"
>>>>>>> 3febdf2ca1a57bb74307fb0956183fd0ae27c724
