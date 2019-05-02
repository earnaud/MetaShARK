rm(list=ls())

### this script shall be called after xsdParser.R

files = dir("tableFiles/", pattern = ".csv")

if(!dir.exists("metadataFieldsTables"))
  dir.create("metadataFieldsTables")

for(file in files){
  # load / create tables
  emlElementsTree <- read.csv(paste0("tableFiles/",file), sep = "\t",
                              stringsAsFactors = FALSE)
  emlElementsTree <- cbind(emlElementsTree,
                           1:length(emlElementsTree[,1]))
  relationTable = data.frame(parent=emlElementsTree[,1],
                             children=rep("None",dim(emlElementsTree)[1])
                             )
  
  relationTable[,2] = c(apply(data.frame(1:(dim(emlElementsTree)[1]-1)),
                        1,
                        function(row){
                          child = "None"
                          i = row+1
                          # while depth is greater
                          print(emlElementsTree[i,2] > emlElementsTree[row,2])
                          while(emlElementsTree[i,2] > emlElementsTree[row,2]){
                            if(i == row+1) child = emlElementsTree[i,1]
                            else child = paste(child,emlElementsTree[i,1], collapse = ",")
                            i = i+1
                          }
                          return(child)
                        }),
                        "None")
  print(relationTable)
  print("####################################")
}
