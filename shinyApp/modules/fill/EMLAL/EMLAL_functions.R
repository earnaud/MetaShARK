# EMLAL.R

# other functions
chooseDirectory = function(caption = 'Select data directory', default = "~/") {
  if (exists('utils::choose.dir')) {
    choose.dir(caption = caption) 
  } else {
    tk_choose.dir(default = default, caption = caption)
  }
}

# create DP directory
createDPFolder <- function(DP.location, DP.name, data.location){
  if(dir.exists(paste0(DP.location, DP.name))){
    unlink(paste0(DP.location,DP.name),recursive = TRUE)
    showModal(modalDialog(
      title = "Information: directory deleted",
      span(paste0(DP.location, DP.name), "has been deleted and replaced by a new empty data package."),
      footer = mmodalButton("Close"),
      easyClose = TRUE
    ))
  }
  
  template_directories(
    path = DP.location, 
    dir.name = DP.name
  )
}