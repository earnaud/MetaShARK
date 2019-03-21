### Function used to parse metadata*.csv files (sep=",") which gather
### information for a type of data. See README.md for more details

library(data.table)

parseMetadataInfo <- function(fileType = character()){
  # 
  fileName = paste0("templateMetadataInfo/templates/metadata",fileType,".csv")
  
  # Load corresponding data
  metadataFields = fread(file="templateMetadataInfo/templates/metadataPersonnel.csv")
  return(metadataFields)
}
