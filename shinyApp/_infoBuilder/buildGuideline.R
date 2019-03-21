### buildGuidelines.R ###
rm(list=ls())
start.time <- Sys.time()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

### libraries ###
library(xml2)
library(purrr)
library(data.tree)

### imports ###
source("~/Documents/libs/R/PersonalUtilities/utilities.R", chdir = TRUE)
source("xsdExplorer.R")

### set vars ###
cat("Setting variables :")
files = dir(path = "xsdFiles",pattern="eml",full.names = TRUE)
focus = c("element", "enumeration", "attribute",
          "import", "complexType", "R-Attributes")
cat("done in", Sys.time() - start.time,"\n"); start.time = Sys.time()

### Guidelines production ###
# Only lists are saved (as it is a more usual format)
cat("Producing the guidelines:\n")

## save full guideline - system guideline ##
cat("* Full guideline:")
{
  lists = buildSystemList(files, focus)
  saveRDS(lists, "../guideLines/SystemGuidelineList.RData")
}
cat("done in", Sys.time() - start.time,"\n"); start.time = Sys.time()

## user guideline ##
cat("* User guideline:")
{
  userList <- buildUserList(lists, focus=focus)
  # (as.list(userTree), focus = c("element", "enumeration", "complexType"))
  saveRDS(userList, "../guideLines/UserGuidelineList.RData")
}
cat("done in", Sys.time() - start.time,"\n")
rm(start.time)