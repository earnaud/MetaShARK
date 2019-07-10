# header.R
rm(list = ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
options(shiny.reactlog=TRUE)

### IMPORTS ----

  ## GUI ----
  library(shiny)
  library(shinyTree)
  library(shinydashboard)
  library(shinyjs)
  library(tcltk2)
  
  ## EML ----
  library(EML)
  library(EMLassemblyline)
  
  ## Utils ----
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
  
  ## Dir creation ----
    if(!dir.exists(".cache/")) dir.create(".cache/")
    DP.path <- "dataPackagesOutput/emlAssemblyLine/"
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