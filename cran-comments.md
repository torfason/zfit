
## Release summary

* This is the initial release of zfit

* Package has been checked locally and on r-hub.io

* R CMD check ran without errors, warnings or notes (apart from "New submission" note)

* Spelling error warnings fixed by removing unneeded references to class names and enclosing references to package names in single quotes (')

* \dontrun{} conditionals have been replaced with if(require("dplyr")){} conditionals. It had been suggested to replace \dontrun{} with \donttest{}, but that does not seem applicable because this is not a long-running calculation.

* Some examples were also modified because the utf8 package is not currently available on Windows buildservers for the development version of R. The examples now use datasets that does not require the utf8 package.
