# header.R
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
options(shiny.reactlog=TRUE)

  ## Global variables ----
    DP.PATH <- paste0(getwd(),"/dataPackagesOutput/emlAssemblyLine/")
    THRESHOLD = list(
      dp_data_files = 500000
    )
    HOME = fs::path_home()

### IMPORTS ----
  #list.of.packages <- c(
  #  # GUI
  #  "shiny", "shinyTree", "shinydashboard", "shinyjs", "shinyFiles", "tcltk2","tippy",
  #  # EML
  #  "EML","EMLassemblyline",
  #  # utils
  #  "devtools"
  #)
  #new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  #if(length(new.packages)) install.packages(new.packages)

  ## Libraries
  # GUI
    library(shiny)
    library(shinyTree)
    library(shinydashboard)
    library(shinyFiles)
    library(shinyjs)
    library(tcltk2)
    library(tippy) 
    
  # EML
    library(EML)
    library(EMLassemblyline)
    
  # Utils
    library(devtools)
    library(RefManageR)

  ## Modules assembly
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
    source("modules/about/about_functions.R")
  # Utils - not GUI
    source("utils/multiApply.R")
    source("utils/reactiveTrigger.R")
  
  ## Dir creation ----
    dir.create(".cache/", recursive = TRUE, showWarnings = FALSE)
    dir.create(DP.PATH, recursive = TRUE, showWarnings = FALSE)

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
      nsIndex <- readRDS("resources/nsIndex.RData")
      message("* Namespaces Index successfully loaded !")
    
    # Bibliography - approximatively the same as 2019 master memoir
      bibliography <- list()
      bibliography$actors <- ReadBib("modules/about/actors.bib")
      message("* Actors bibliography successfully loaded !")
      bibliography$informatics <- ReadBib("modules/about/informatics.bib")
      message("* Informatics bibliography successfully loaded !")
      bibliography$ecology <- ReadBib("modules/about/ecology.bib")
      message("* Ecology bibliography successfully loaded !")
    
  ## Id Module ----
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
    
### MISC ZONE ----
# Tippy real examples
# https://cran.r-project.org/web/packages/tippy/readme/README.html