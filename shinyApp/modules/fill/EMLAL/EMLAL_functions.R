# EMLAL.R

# other functions
chooseDirectory = function(caption = 'Select data directory', default = DP.path) {
  if (exists('utils::choose.dir')) {
    choose.dir(caption = caption) 
  } else {
    tk_choose.dir(default = default, caption = caption)
  }
}

# create DP directory
createDPFolder <- function(DP.location, DP.name){
  if(dir.exists(paste0(DP.location,DP.name))){
    unlink(paste0(DP.location,DP.name),recursive = TRUE)
    showModal(modalDialog(
      title = "Information: directory deleted",
      span(paste0(DP.location, DP.name), "has been deleted and replaced by a new empty data package."),
      modalButton("Close")
    ))
  }
  
  template_directories(
    path = DP.location, 
    dir.name = DP.name
  )
}