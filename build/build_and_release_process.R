
## Assume a clean checkout, typically from Github,
## but alternatively from a parallel directory
# > git clone https://github.com/torfason/zfit
# > git clone ../zfit

## Cleanup tasks are not run (build actual Github contents)
# devtools::clean_vignettes()
# pkgdown::clean_site()

## Ensure all documentation builds without errors
devtools::document()
devtools::build_readme()
devtools::build_vignettes()
devtools::build_site()
devtools::build_manual()

## Do the final checking steps
devtools::spell_check()
devtools::build()
devtools::test()
devtools::check()
devtools::release_checks()
devtools:::git_checks()

## Remote checks
## (commented out, copy to terminal and run manually)
# devtools::check_rhub()
# devtools::check_win_devel()

## Finally submit to cran
## (commented out, copy to terminal and run manually)
# devtools::release()

