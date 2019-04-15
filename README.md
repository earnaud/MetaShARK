# ARSE
Automated R Shiny EML.
_First released on 15-04-2019_

The aim of the ARSE app is to allow any user a bit familiar with ecology to fill in data packages to provide as many information as possible on any dataset used in a publication, communication, etc. in ecology. The challenge of this work is to produce a user-friendly tool to a science community which is not familiar to heavy metadata standards and their informatic specification. Consequently, the choice has been made to work only with R as it is the currentest programming language in this community and it can be easily accessible as an open source application, despite of its low performances.
This project has the ambition to offer the user a user-friendly alternative to existing tools (such as the hardcore Morpho ;) ) but also to address an other issue which is the EML is not always fully considered (such as in the [AssemblyLine](https://github.com/EDIorg/EMLassemblyline).

**Any suggestion is welcome, feel free to contact the dev !**

## Running ARSE
You can launch the app through the 'main.R' script (shinyApp/main.R). The supported features and expected behaviors are described below.

### Required libraries

ARSE require two libraries to perform:
* [shiny](https://shiny.rstudio.com/)
* [shinyTree](https://github.com/shinyTree/shinyTree)

## Releases

### Release 20190415

#### Features
The tool allows to browse the documentation contained at any level of the EML XML schema (v. 2.1.1). The links to external sites have been implemented but the references between the modules are not. Content is based on the EML Schema provided through the [NCEAS eml repo](https://github.com/NCEAS/eml).

## Next goals
Here is the expected plan for further releases:
* Add a 'Edit Content' section, which shall permit the user to enter an EML data package's content modularly. The filling will be controlled at its input directly through the app. The filled content will be saved in modules in a local cache.
* Add a 'Generate EML data package' section which shall gather EML content modules into a full EML file. The EML data package would be validated and then exported into an XML file.
* Add connections to other services for different purposes. For example, Orcid to automate the user identification.
* Make the app as an executable.
* Produce a mapping of the EML terms by other standards (Darwin Core, ISO 19115, ...) and integrate it into the app.
* Make ARSE accessible through Galaxy-E.

## Authors
* Elie Arnaud (developper) - elie.arnaud@mnhn.fr
