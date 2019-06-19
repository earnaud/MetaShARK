
# MetaShARK
Metadata Shiny-Automated Resources & Knowledge
_First released on 15-04-2019_

The aim of the MetaShARK app is to allow any user a bit familiar with ecology to fill in data packages to provide as many information as possible on any dataset used in a publication, communication, etc. in ecology. The challenge of this work is to produce a user-friendly tool to a science community which is not familiar to heavy metadata standards and their informatic specification. Consequently, the choice has been made to work only with R as it is the currentest programming language in this community and it can be easily accessible as an open source application, despite of its low performances.
This project has the ambition to offer the user a user-friendly alternative to existing tools (such as the hardcore Morpho ;) ) but also to address an other issue which is the EML is not always fully considered (such as in the [AssemblyLine](https://github.com/EDIorg/EMLassemblyline)).

**Any suggestion is welcome, feel free to contact the dev !**

## Running MetaShARK
You can launch the app through the 'main.R' script (shinyApp/main.R). The supported features and expected behaviors are described below.

### Required libraries

ARSE require following libraries to perform:
* [shiny](https://shiny.rstudio.com/)
* [shinyTree](https://github.com/shinyTree/shinyTree)
* [shinydashboard](https://github.com/rstudio/shinydashboard)
* [shinyjs](https://deanattali.com/shinyjs/)
* [EMLassemblyline](https://github.com/EDIorg/EMLassemblyline) for the corresponding `Fill in` module

## Releases

### Release 20190507

#### Features
* The tool still allows only the documentation browsing. The support has been moved from basic shiny style to the shiny Dashboard style. With this feature comes easier ways to organize the UI for future steps. 
* The whole repository architecture has been remade, which caused difficulties on uploading the latest version. 
* A \_old directory has been created at the root to store old files which could still be useful later. Any documentation about them shall be contained within it as comments for scripts or data labels for other files.

### Release 20190415

#### Features
The tool allows to browse the documentation contained at any level of the EML XML schema (v. 2.1.1). The links to external sites have been implemented but the references between the modules are not. Content is based on the EML Schema provided through the [NCEAS eml repo](https://github.com/NCEAS/eml).

## Next goals
Here is the expected plan for further releases:
* Add a 'Fill Content' section, which shall permit the user to enter an EML data package's content modularly. The filling will be controlled at its input directly through the app. The filled content will be saved in modules in a local cache.
* Add a 'Generate EML data package' section which shall gather EML content modules into a full EML file. The EML data package would be validated and then exported into an XML file.
* Add connections to other services for different purposes. For example, Orcid to automate the user identification.
* Make the app as an executable.
* Produce a mapping of the EML terms by other standards (Darwin Core, ISO 19115, ...) and integrate it into the app.
* Make MetaShARK accessible through Galaxy-E.

## Authors
* Elie Arnaud (developper) - elie.arnaud@mnhn.fr

## Contribute
Any contribution can be done and submitted. To contribute, please refer the 'contributing.md' file.

## Submit issues
For anny issue submittance, please add a single-word tag in bracket before the title of your issue. Do not hesitate also to describe it exhaustively and add a label.

