
## R CMD check results

There were no ERRORs or WARNINGs, or NOTEs in local builds

There was one note when using r-hub.io:

* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
  
This note is not reproducible locally or on win-builder, 
and seems not to affect the output, because the check 
reports no errors related to the PDF version of the manual:

#> * checking PDF version of manual ... OK

## Downstream dependencies

There are currently no downstream dependencies for this package


## Release summary

* This is the 0.3.0 release of zfit

* Package has been checked locally and on r-hub.io

* R CMD check ran without errors, warnings or notes, apart from "lastMiKTeXException" note
