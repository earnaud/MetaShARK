# This tool is set up on the EML 2.1.1 release's .xsd files provided
# on their official git (https://github.com/NCEAS/eml) on 2019/02/25


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

path = "xsdFiles/"

outpath = "tableFiles/"

xsdParser <- function(path, outpath){
  if(!dir.exists(outpath)) dir.create(outpath)
  
  # Load files
  files = dir(path, pattern = "eml")
  
  # Files loop
  for(file in files){
    
    # Scalar initialization
    emlElementsTree = data.frame(element=character(),
                                 depth=integer(),
                                 sequence = numeric(),
                                 choice = numeric())
    depth = 0
    lineNb = 1
    inSequence = 0
    inChoice = 0
    
    # verbose
    print(paste("Processing", file))
    con = file(paste0(path, file), "r")
    
    # Line loop
    while ( TRUE ) {
      line = readLines(con, n = 1)
      lineNb = lineNb + 1
      if ( length(line) == 0 ) {
        break
      }
      
      # Sequence opening
      if(grepl("<xs:sequence", line))
      {
        inSequence = c(inSequence, lineNb)
        # print(line)
      }
      # Sequence closing
      if(grepl("</xs:sequence", line)) 
      {
        inSequence = inSequence[-length(inSequence)]
        # print(line)
      }
      
      # Choice opening
      if(grepl("<xs:choice", line)) 
      {
        inChoice = c(inChoice, lineNb)
        # print(line)
      }
      
      # Choice closing
      if(grepl("</xs:choice", line)) 
      {
        inChoice = inChoice[-length(inChoice)]
        # print(line)
      }
  
      
      # Element found
      if(grepl("<xs:element name", line) || grepl("<xs:element ref", line)){
        toAdd = data.frame(unlist(strsplit(line, "\""))[2],
                           depth,
                           inSequence[length(inSequence)],
                           inChoice[length(inChoice)])
        colnames(toAdd) = colnames(emlElementsTree)
        
        emlElementsTree = rbind(emlElementsTree,
                                toAdd)
        depth = depth+1
      }
      # Closing element
      if(grepl("</xs:element", line)){
        depth = depth-1
      }
      
    }
    close(con)
    
    write.table(emlElementsTree,
                paste0(outpath,
                       gsub(".xsd","",gsub("eml-","",file))
                       ,".csv"),
                sep = "\t",
                quote=TRUE,
                col.names = TRUE,
                row.names = FALSE)
  }
}
