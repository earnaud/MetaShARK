# xsdExplorer.R

# This tool is set up on the EML 2.1.1 release's .xsd files provided
# on their official git (https://github.com/NCEAS/eml) on 2019/02/25

# IMPORTS

# source("~/Documents/libs/R/PersonalUtilities/utilities.R", chdir = TRUE)
source("guidelinesFunctions.R")

# Build hierarchy 
buildSystemList <- function(files, focus)
{
  # read files
  lists <- lapply(files, function(file){
    return(as_list(read_xml(file)))
  })
  # renames first-level lists (files' lists)
  names(lists) <- sapply(files, 
                        function(file){
                          gsub("xsdFiles/","",
                               gsub("\\.xsd","",file)) 
                        })
  # Prepare recursion
  toApplyFUNS = list(
    quote(addRAttributes), # first as attributes are fragile structures in R
    quote(renameName),
    quote(addPathway)
  )
  
  toApplyARGS = list(
    list(NA),
    list(focus),
    list(quote(path))
  )
  # apply recursion
  lists <- multiApply(lists, toApplyFUNS, toApplyARGS)
  # l2 <- lists; View(l2)
  return(lists)
}

# make the hierarchy from `buildLists` as a user-friendly list
# - Make names user-friendly
buildUserList <- function(li, focus){
  # prepare recurstion
  toApplyFUNS = list(
    quote(movedTypedElements),
    quote(shortNames)
  )
  toApplyARGS = list(
    list(NA),
    list("^.*(_|:)")
  )
  # apply recursion
  userList <- multiApply(li, FUNS = toApplyFUNS, ARGS = toApplyARGS)
  browser()
  Prune(userTree,
        pruneFun = function(node){
          return(tree.find(node, c("complexType","element")))
        })
  return(userList)
}


