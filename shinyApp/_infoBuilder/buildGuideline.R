### buildGuidelines.R ###
rm(list=ls())
start.time <- Sys.time()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))



### libraries ###
library(xml2)
library(data.tree)



### imports ###
# source("~/Documents/libs/R/PersonalUtilities/utilities.R", chdir = TRUE)
source("xsdExplorer.R")



### set vars ###
{
  cat("Setting variables : ")
  files = dir(path = "xsdFiles",pattern="eml",full.names = TRUE)
  focus = c("element"
            , "simpleType"
            , "attribute"
            , "group"
            , "complexType"
            , "R-Attributes"
            , "simpleContent")
  filter = c("simpleType:"
             , "complexType:"
             , "simpleContent:"
             , "element:"
             , gsub("xsdFiles/","", gsub("\\.xsd","",files))
             )
  cat(round(Sys.time() - start.time, 1),"s.\n"); start.time = Sys.time()
}



### Guidelines production ###
# Only lists are saved (as it is a more usual format)
cat("Producing the guidelines:\n")


  ## system guideline ##
  {
    cat("* Full guideline: ")
    systemList = buildSystemList(files, focus)
    saveRDS(systemList, "../guideLines/SystemGuidelineList.RData")
    cat(round(Sys.time() - start.time, 1),"s.\n"); start.time = Sys.time()
  }
  

  ## user guideline ##
  {
    cat("* User guideline: ")
    userList <- buildUserList(li = systemList, focus=focus, filter = filter)
    saveRDS(userList, "../guideLines/UserGuidelineList.RData")
    cat(round(Sys.time() - start.time, 1),"s.\n")
  }


# rm(list = ls())
