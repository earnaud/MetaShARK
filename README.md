# R - Ecology MetaData gatherer

## Introduction
This tool provides a UI (R shinyApp) to allow any user to fill in information which matches the Ecology Metadata Language (EML) standard. This UI relies on EML Assembly Line which is in charge of getting the formatted information (into templates files) and make EML files with those. Consequently,
R-EMD is focused on filling those templates files.

## Git Structure
The following tree is generated with the bash package 'tree'. Folders ending with '/' contain only files that are not informative (e.g. only called while scripts are used).
.
├── README.md
└── shinyApp
    ├── _infoBuilder
    │   ├── csvMerger.R
    │   ├── metadataFieldsTables
    │   ├── tableFiles/
    │   ├── xsdFiles/
    │   ├── xsdParser.py
    │   └── xsdParser.R
    ├── main.R
    ├── templateApp
    │   ├── templateApp.R
    │   └── templateModule.R
    └── templateMetadataInfo
        ├── parseMetadataInfo.R
        └── templates
            └── metadataPersonnel.csv

8 directories, 58 files

## Releases
No releases yet. This is to be considered as a 'EML-assembly line'-dependant tool.
