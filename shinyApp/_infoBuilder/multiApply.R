### multiApply.R

# Can be used as template for recursive list function
# @param target: the list on which the FUNS will be applied
# @param FUNS: list of functions
# @param ARGS: list of arguments matching FUNS. Caution ! The elements in ARGS
#              shall be concatenated in a vector if possible. Else, send a 
#              pointer (list names or so). Remember you do not need to input
#              target in the ARGS list
# @param path: if a FUN explicitly needs the path followed from the 0th-level, 
#              it can be accessed by figuring it clearly as 'path' in the function
#              arguments.
multiApply <- function(target, 
                       FUNS = list(),
                       ARGS = rep(NA, length(FUNS)),
                       path = "Root"){
  #- Validity checks
  if(length(FUNS) != length(ARGS)
     && !is.na(ARGS)) 
    stop("FUNS and ARGS length differ !")
  
  if(length(FUNS) == 0) 
    stop("FUNS shall not be empty")
  
  if(!is.list(target)) return(target)
  
  #- Recursion
  if(!is.null(attributes(target)))
    target.attributes <- attributes(target)
  target <- lapply(seq_along(target),
                   function(t,f,a,p,i){
                     multiApply(t[[i]], f, a,
                                paste(path, names(t)[i], sep="/"))
                   }, 
                   t = target,
                   f = FUNS,
                   a = ARGS,
                   p = character())
  if(exists("target.attributes"))
    attributes(target) <- target.attributes
  
    
  #- Apply FUNS
  for(i in 1:length(FUNS)){

    # argumented functions
    if(!is.na(ARGS[[i]])){
      # browser()
      ARG = unlist(ARGS[[i]])
      if(is.list(ARG)) ARG <- ARG[[1]] # Specific !!
      if(is.symbol(ARG)) ARG <- eval(ARG)
      
      
      target <- lapply(list(target),
                       FUNS[[i]],
                       ARG
                      )[[1]]
    }
    
    # object-only functions
    else {
      target <- lapply(list(target),
                       FUNS[[i]]
                       )[[1]]
    }
  }
  return(target)
}