
interpreteTypes <- function(type){
  type = data.frame(strsplit(type,sep=c("(",")")))
  colnames(type)=c("type","length")
  
}

parseMetadataInfo <- function(fileType = character()){
  # Load corresponding data
  metadataFields = read.table(file="templateMetadataInfo/templates/metadataPersonnel.csv",
                              sep=",", header = TRUE, stringsAsFactors = FALSE)
  metadataFields = cbind(metadataFields[,1:3],
                         unlist(lapply(metadataFields[,3], typeof)),
                         metadataFields[4])
}
