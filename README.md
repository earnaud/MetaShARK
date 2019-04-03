# R-EMD
R Ecology MetaData gatherer. Relies on shinyApp R library. 
This app is currenlty in dev.

## Update 2019-04-03
**Launching the shinyApp is possible**
1) Source the "buildGuidelines.R" script ("shinyApp/_infoBuilder/buildGuidelines.R")
2) Launch the shinyApp: load main.R ("shinyApp/") in Rstudio and click the "Run App" icon (top-right of script editor)

**features**
The expected behavior is a tree display (that might overflow its area) of a fraction of the EML structure. By clicking on a *node* the app will show a path valid within the displayed tree. By clicking on a *leaf* the app will show a path valid within the Full EML schema tree ("shinyApp/guidelines/SystemGuidelineList.RData").
