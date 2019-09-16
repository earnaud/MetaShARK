# How to contribute writing code in MetaShARK

## Motivation
As the project grows in size and code lines, it appears its design is not clean, and the design pattern are not fully respected. Also, this document is re-factored to explain 1/ the naming convention followed in MetaShARK and 2/ how to organize the files.

## Naming convention
The naming convention is inspired by the [Python naming convention](https://www.python.org/dev/peps/pep-0008/#package-and-module-names)

**variables**
*localVar*	variables are named in lowercase letters 'camelCase'.  
*GLOBAL.VAR*	global variables (defined outside any function) are named with capital letters, and separated with dots.
*Class*		class are named as variables, but their names begin with a capital letter

**functions**
*longFunction*	functions are named in lowercase letters 'camelCase'. Referencing a function is done as follow: `function()` (with "`").

**files**  
*aScript.R*	scripts are named in lowercase letters 'camelCase'.  
*aFolder*	folders are named in lowercase letters 'camelCase'.  
*DOC.md*	(re-)user-end documents are named in capital letters.  
*resource-image_date.png*	other files are named in lowercase. Words are separated with "-" for replace spaces and "\_" for separating themes.  

**R Shiny IDs**
*namespace*	namespaces are named within a vector, as the first element. Each vector corresponds to a module, structured as follow:
* ID Module (also called IM): built pasting "<nameofthemodule>" and "Module".
* nameofthemodule : name of the module (generally one word *or* one logo - e.g. EMLAL stands for EML Assembly Line)
* otherids[] : a vector of any ids used in the Shiny ui-server interactions
*element-type*	element are named (through their 'id' argument) in lowercase separated with "-". They shall be built as follow `id-type[-misc]` with type the structure of the element.
*\*put.ids*	in/output elements ids in the server are named in lowercase separated with dots. They shall be built as follow `what.info` with *what* the informative element and *info* the action/information contained about *what*.

##
For the **Fill/EMLAL** module, a specific variable is built: *fill*. It is of type `list` and contains `reactiveValues` in its leaves. Intermediate levels are sub-lists. The variable is built as follow:  
. fill  
├- emlal  
|  ├- selectDP  
|  ├- createDP  
└- metafin  
The building logic is:  
* *root* is a list with elements corresponding to each metadata filling module (EML Assembly Line, MetaFIN).
* 1st level nodes match filling module and contain sublist for each step of the filling process.
* 2nd level nodes' elements are `reactiveValues` object containing the filled metadata.  
Each of the modules node are returned at the end of their respective module. While reading a module, beware of the way their input is written.  

## Git files organization
+ _old
+ shinyApp
+ templateApp
