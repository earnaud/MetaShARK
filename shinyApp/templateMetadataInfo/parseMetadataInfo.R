### Function used to parse metadata*.csv files (sep=",") which gather
### information for a type of data. See README.md for more details

parseMetadataInfo <- function(fileType = character()){
  # 
  fileName = paste0("templateMetadataInfo/templates/metadata",fileType,".csv")
  
  # Load corresponding data
  metadataFields = read.table(file="templateMetadataInfo/templates/metadataPersonnel.csv",
                              sep=",", header = TRUE, stringsAsFactors = FALSE)
  # metadataFields = cbind(metadataFields[,1:3],
  #                        unlist(lapply(metadataFields[,3], typeof)),
  #                        metadataFields[4])
  return(metadataFields)
}
