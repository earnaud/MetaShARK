# How to contribute writing code in MetaShARK

## Motivation
As the project grows in size and code lines, it appears its design is not clean, and the design pattern are not fully respected. Also, this document is re-factored to explain 1/ the naming convention followed in MetaShARK and 2/ how to organize the files.

## Naming convention
The naming convention is inspired by the [Python naming convention](https://www.python.org/dev/peps/pep-0008/#package-and-module-names)

**variables**  
*local_var*	variables are named in lowercase "snake_case": prefer using underscores to dots to avoid conflict with javascript inserts.  
*GLOBAL.VAR*	global variables (defined outside any function) are named with capital letters, and separated with dots.  
*Class*		class are named as variables, their names begin with a capital letter  

**functions**  
*longFunction*	functions are named in lowercase letters 'camelCase'. Referencing a function is done as follow: `function()` (with "`").  

**files**  
*aScript.R*	scripts are named in lowercase letters 'camelCase'.  
*aFolder*	folders are named in lowercase letters 'camelCase'.  
*DOC.md*	(re-)user-end documents are named in capital letters.  
*resource.png*	other files are named in lowercase. Words are separated with "-" to replace spaces and "\_" to separate themes.  

**R Shiny IDs**  
*namespace*	namespaces are named within a vector, as the first element. Each vector corresponds to a module, structured as follow:  
* ID Module (also called IM): built pasting "<nameofthemodule>" and "Module".  
* nameofthemodule : name of the module (generally one word *or* one logo - e.g. EMLAL stands for EML Assembly Line)  
* otherids[] : a vector of any ids used in the Shiny ui-server interactions  
*element-type*	element are named (through their 'id' argument) in lowercase separated with "-". They shall be built as follow `id-type[-misc]` with type the structure of the element.  
*\*put_ids*	in/output elements ids in the server are named in lowercase "snake_case": prefer using underscores to dots to avoid conflict with javascript inserts. They shall be built as follow `what_info` with *what* the informative element and *info* the action/information contained about *what*.  

## Git files organization
\[not stable\]
