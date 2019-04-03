### guidelinesFunctions.R ###

### Conventional naming:
# @param li for target lists



# Add the result of attributes() as a child element of the list
# @param l: targetted list
addRAttributes <- function(li = list()){
  #- Validity check
  check = attributes(li)
  if(is.null(check)) return(li)
  # check = check[names(check) != "names"]
  # if(length(check) == 0) return(li)
  check = check[check != ""]
  if(length(check) == 0) return(li)
  rm(check)
  
  #- Prepare vector to add with mature children
  # For further compatibility ('data.tree' package), names are switched to uppercase
  toAdd <- attributes(li)
  attr(toAdd, "names") <- toupper(gsub("^attr\\(,","",
                                       gsub("\\)$","",
                                            attr(toAdd, "names")
                                       )
  )
  )
  
  # add prepared vector - replaces attributes of l
  if(length(li)==0){
    li <- list("R-Attributes" = toAdd )
  }
  else{
    li <-c(li, list("R-Attributes" = toAdd ))
  }
  
  return(li)
}

# If an element of @filter is found in the names of the list, it is renamed by
# pasting this element as prefix
# # This function has an EML-specific feature linked to 'name' attributes (not 'names')
# @param l: targetted list
# @param filter: vector of words to catch. If those are catched, the function
#                will fetch for their 'name' attributes (EML-specific) and 
#                paste them as a suffix to the list element name
# @param numbers: logical. If TRUE, each list's elements' names will be
#                 suffixed with their position number in this list level.
renameName <- function(li = list(), filter = character(), numbers = TRUE){
  #- Validity checks
  if(!is.list(li) || length(li) == 0) return(li)
  
  
  if(numbers){
    
    if(length(attr(li, "names")[attr(li, "names") != "R-Attributes"]) != 0){
      toAdd <- attr(li, "names")[attr(li, "names") != "R-Attributes"]
      toAdd <- paste0(1:length(toAdd),"_",toAdd)
      attr(li, "names")[attr(li, "names") != "R-Attributes"] <- toAdd
    }
    
  }
  
  # if(isFound("group", attr(l,"names"))) browser()
  
  #- main loop
  i <- 1
  while(i <= length(li)){
    # if something interesting is found among the names of li, rename it
    
    if(isFound(filter, attr(li,"names")[i])
       && "NAME" %in% attr(li[[i]][["R-Attributes"]], "names")){ # !!! XML-specific 
      nameToSet = paste0(
        attr(li,"names")[i],
        ":", li[[i]][["R-Attributes"]][["NAME"]]
        )
      attr(li,"names")[i] <- nameToSet
      
    } # end if
    i <- i+1
    
  } # end while
  
  # EML-specific exception
  if(any(grepl("R-Attributes", attr(li,"names"))))
    attr(li,"names")[grepl("R-Attributes", attr(li,"NAMES"))] <- "R-Attributes"

  return(li)
  
}




# add paths in hierarchy (in "R-Attributes") to reach the node
# @param li: targetted list
# @param path: fetches the parent function arguments to get the one named
#              "path". Caution !!! Using this function requires to write
#              another path in this argument or call it from a function
#              keeping a track of the path (see multiApply). More, the path
#              is not to be confused with the "path" from 'data.tree' 
#              package (used later)
addPathway <- function(li, path){
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
    li[["R-Attributes"]][["XSDPATH"]] <- "Root"
  else
    li[["R-Attributes"]][["XSDPATH"]] <- path
  
  return(li)
}


# prune a list from branches which don't contain focused words.
# pruneList <- function(li, filter){
#   if(!is.list(li))
#     return(li)
#   # remove simply any branch named after filter$prune
#   li <- li[!sapply(attr(li, "names"),
#                function(n,
#                         f = filter$prune){
#                  return(any(grepl(n, f)))
#                })]
#   # flatten elements found in filter$flatten
#   sapply(filter$flatten,
#          function(f){
#            if(any(grepl(f,attr(li,"names")))){
#              tmp <- unlist(li[grepl(f, attr(li,"names"))], recursive = FALSE)
#              attr(tmp,"names") <- paste0(gsub(".*\\.","",attr(tmp,"names")),
#                                          "_",
#                                          which(grepl(f, attr(li,"names"))))
#              li <- replace(li, which(grepl(f, attr(li,"names"))), tmp)
#              browser()
#            }
#          })
#   # 
#   
#   if(any(grepl("choice",names(li)))) browser()
#   return(li)
# }

# flatten lists levels that aren't user-friendly
# as it works on list levels' children, it is compatible with the
# 'setPath' option of multiApply()
flatten <- function(li, filter){
  if(!has_child(li))
    return(li)
  # flatten the list level if it is not user-friendly
  # if(grepl("schema",attr(li,"names"))) browser()
  if(!isFound(filter, names(li))){
    li <- unlist(li, recursive = FALSE) # get back one list level
    if(!is.null(names(li)))
      names(li) <- gsub("^.*\\.","",names(li))
  }
  return(li)
}

# make all names shorter according to the pattern
# @param li: list whose names will be shortened
# @param pattern: regex to look for to trigger names shortening
betterNames <- function(li){
  if(!is.list(li) || is.null(names(li))) return(li)
  attr(li, "names") = gsub("(_).+:", "\\1", attr(li, "names"))
  attr(li, "names") = gsub("([a-z])([A-Z])","\\1 \\2", attr(li, "names"))
  return(li)
}

# # Ensure there are no resting 'R-Attributes' (except if containing TYPE) list at the end of a recursion
removeRAttributes <- function(li){
  if(!has_child(li))
    return(li)
  
  if(!isFound("R-Attributes", attr(li,"names")))
    return(li)
  return(li[attr(li,"names") != "R-Attributes"])
}

# Make the final list a bit more pretty
prettyList <- function(li, path){
  
  # clean the elements named 'schemaX' with X a digit
  li <- li[!grepl("schema[0-9]$",attr(li, "names"))]
  if(has_child(li))
    li[which(sapply(li,
                    function(ll) identical(ll, list())))] <- path
  li <- li[li != "[ comment ]"]
  return(li)
}



# --- Utility Functions --- #
# Some tiny useful tools inserted
# Instead of using a package

# -- General

# @overwrite
replace <- function(x, ind, values){
  if(ind == length(x))
    x = c(x[-ind], values)
  else if(ind == 1)
    x = c(values,x[-1])
  else
    x = c(x[1:ind-1], values, x[ind+1:length(x)])
  return(x)
}

# -- Lists

# Get depth of a list
getListMaxDepth <- function(li, depth=0){
  # empty list
  if(!is.list(li) || length(li) == 0)
    return(depth)
  # non-empty list
  return(max(unlist(lapply(li,getListMaxDepth,depth=depth+1))))    
}

# check if one of the children of the input list is a list
has_child <- function(li){
  if(!is.list(li)) return(FALSE)
  return(any(sapply(li, is.list)))
}


# -- Regex

# Makes a vector of pattern match a string or a vector of strings
# Patterns can be listed
isFound <- function(pattern, string){
  if(is.null(string)) return(FALSE)
  if(is.list(pattern)) pattern=unlist(pattern)
  if(is.list(string)) string=unlist(string)
  return(any(sapply(pattern, function(pat)
    grepl(pat, string))))
}

# -- Data trees

require(data.tree)

# does an element exist in childhood
tree.find = function(node, focus.vec){
  if(is.list(node)) node <- as.Node(node)
  elements <- Traverse(node, filterFun = function(node) any(sapply(focus.vec, function(f) grepl(f,node$name))))
  return(length(elements) > 0)
}