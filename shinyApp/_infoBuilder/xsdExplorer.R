# xsdExplorer.R

rm(list=ls())
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# This tool is set up on the EML 2.1.1 release's .xsd files provided
# on their official git (https://github.com/NCEAS/eml) on 2019/02/25

# IMPORTS
library(xml2)
library(rvest)
library(ddpcr)
library(purrr)
library(data.tree)
library(jsonlite)

# source("utilities.R")


files = dir(path = "xsdFiles",pattern="eml",full.names = TRUE)

lists = list()
lists = lapply(files, function(file){
  return(as_list(read_xml(file)))
})


names(lists) = sapply(files, 
                      function(file){
                        gsub("xsdFiles/","",
                             gsub("\\.xsd","",file)) 
                      })

# To use for visualization purposes 
# 
# countingName <- function(list){
#   if(!is.list(list) | length(list)==0)
#     return(list)
#   names(list) = paste(1:length(list),names(list),sep="_")
#   list = lapply(list, countingName)
# }
# 
# lists=countingName(lists)

View(lists) # bug on display

# data.tree package use

test = lists$`eml-dataset`$schema$complexType
test.tree = as.Node(test,mode = "simple")

