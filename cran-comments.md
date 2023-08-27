
## R CMD check results

There were no ERRORs or WARNINGs, or NOTEs in local builds or on win-builder.

There were two notes when using r-hub.io (Windows Server only):

* checking for non-standard things in the check directory ... NOTE
Found the following files/directories:
  ''NULL''

* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
  
These notes are not reproducible locally, on other r-hub.io platforms, or on win-builder, and they not to affect the output, because the check reports no errors related to the PDF version of the manual:

#> * checking PDF version of manual ... [12s] OK

## Downstream dependencies

There are currently no downstream dependencies for this package


## Release summary

* This is the 0.4.0 release of zfit

* Package has been checked locally and on r-hub.io

* R CMD check ran without errors, warnings or notes, apart from the specific issue noted above
