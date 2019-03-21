### guidelinesFunctions.R ###

# import
source("multiApply.R")

# If an element of @filter is found in the names of the list, it is renamed by
# pasting this element as prefix
# # This function has an EML-specific feature linked to 'name' attributes (not 'names')
# @param l: targetted list
# @param filter: vector of words to catch. If those are catched, the function
#                will fetch for their 'name' attributes (EML-specific) and 
#                paste them as a suffix to the list element name
# @param numbers: logical. If TRUE, each list's elements' names will be
#                 suffixed with their position number in this list level.
renameName <- function(l=list(), filter=character(), numbers = TRUE){
  #- Validity checks
  if(!is.list(l) || length(l) == 0) return(l)
  
  
  if(numbers)
    attr(l,"names") <- paste0(1:length(l),"_",attr(l, "names"))
                
  #- main loop
  i <- 1
  # browser()
  while(i <= length(l)){
    # if something interesting is found among the names of li,
    # rename it
    if(isFound(filter, attr(l[i],"names"))
       && "name" %in% attr(l[[i]][["R-Attributes"]], "names")){ # !!! EML-specific 
      
      nameToSet = paste0(
        attr(l[i],"names"),
        ":", l[[i]][["R-Attributes"]][["name"]])
      names(l)[i] <- nameToSet
      
    } # end if
    i <- i+1
    
  } # end while
  
  # EML-specific exception
  if(any(grepl("R-Attributes", attr(l,"names"))))
    attr(l,"names")[grepl("R-Attributes", attr(l,"names"))] <- "R-Attributes"

  return(l)
  
}

# Add the result of attributes() as a child element of the list
# @param l: targetted list
addRAttributes <- function(l){
  #- Validity check
  check = attributes(l)
    if(is.null(check)) return(l)
  check = check[names(check) != "names"]
    if(length(check) == 0) return(l)
  check = check[check != ""]
    if(length(check) == 0) return(l)
  rm(check)
  
  #- Prepare vector to add with mature children
  toAdd <- attributes(l)
  attr(toAdd, "names") <- gsub("^attr\\(,","",
                               gsub("\\)$","",
                                    names(toAdd)
                                    )
                               )
  
  # add prepared vector - replaces attributes of l
  if(length(l)==0){
    l <- list("R-Attributes" = toAdd )
  }
  else{
    l <-c(l, list("R-Attributes" = toAdd ))
  }
  
  return(l)
}


# add paths in hierarchy (in "R-Attributes") to reach the node
# @param li: targetted list
# @param path: fetches the parent function arguments to get the one named
#              "path". Caution !!! Using this function requires to write
#              another path in this argument or call it from a function
#              keeping a track of the path (see multiApply)
addPathway <- function(li, path = as.list(match.call(sys.function(-2), sys.call(-2)))$path){
  
  
  #- Validity checks
  if(!is.list(li))
    return(li)
  
  if(is.list(li) && length(li) == 0)
    return(NULL)
  
  # names the li elements if there are some that need
  if(any(is.na(attr(li,"names"))))
    attr(li,"names")[is.na(attr(li,"names"))] = paste("n_", which(is.na(attr(li,"names"))))

    # check if a 'R-Attributes' field exist: where to save the pathway
  if(!('R-Attributes' %in% attr(li,"names"))){ # add a 'R-Attributes' element
    li[["R-Attributes"]] <- list()
  }
  
  #- save the pathway of the current node as a vector of character,
  # identically as in 'data.tree' package
  if(is.null(path))
    li[["R-Attributes"]][["_path"]] <- "Root"
  else
    li[["R-Attributes"]][["_path"]] <- path
  
  return(li)
}

# make all names shorter according to the pattern
# @param li: list whose names will be shortened
# @param pattern: regex to look for to trigger names shortening
shortNames <- function(li, pattern = ""){
  if(!is.list(li) || is.null(names(li))) return(li)
  if(pattern == ""){
    warning("Useless pattern: nothing will be changed with \"\"\n")
    return(li)
  }
  names(li) = gsub(pattern, "", names(li))
  return(li)
}

# Move elements with attr:type = complexType instead of complexType
moveTypedElements <- function(li){
  #- Validity checks
  if(!is.list(li)
     || getListMaxDepth(li) < 2
     || (grepl("element", attr(l,"names"))
         && grepl("complexType", attr(l,"names")))
     )
    return(li)
  
  # check if the elements have a 'type' R-Attribute
  check <- li[grepl("element", attr(li, "names"))]
  check <- check[lapply(check, function(el){
                        if("R-Attributes" %in% attr(el, "names")){
                          if("type" %in% attr(el[["R-Attributes"]], "names")){
                            return(TRUE)
                          }
                        }
                        return(FALSE)
                      })]
  if(length(check) == 0)
    return(li)
  
  #- Fetch elements having a complexType 'type' attribute
  checked <- lapply(check, function(el){
    if(el[["R-Attributes"]][["type"]] %in% names(li))
      return(el[["R-Attributes"]][["type"]])
    else(return("TO-DELETE"))
  })
  checked <- checked[checked != "TO-DELETE"]
  
  #- 
}

# --- Utility Functions --- #

# Get depth of a list
getListMaxDepth <- function(list, depth=0){
  # empty list
  if(!is.list(list))
    return(depth)
  # non-empty list
  return(max(unlist(lapply(list,getListMaxDepth,depth=depth+1))))    
}
