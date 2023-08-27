
## Assume a clean checkout, typically from Github,
## but alternatively from a parallel directory
# > git clone https://github.com/torfason/zfit
# > git clone ../zfit

## Cleanup tasks are not run (build actual Github contents)
# devtools::clean_vignettes()
# pkgdown::clean_site()

## Run this before any commit
devtools::spell_check()
devtools::document()
devtools::build_readme()
devtools::build_vignettes()

## Run to check website and/or manual (after the first four)
devtools::build_site()
devtools::build_manual()

## Do the final checking steps before release
devtools::spell_check()
urlchecker::url_check()
devtools::build()
devtools::test()
devtools::check()
devtools::check(remote = TRUE, manual = TRUE)
devtools::release_checks()
devtools:::git_checks()

## Remote checks
## (commented out, copy to terminal and run manually)
# revdepcheck::revdep_check(num_workers = 4) # (usethis::use_revdep())
# devtools::check_rhub()
# devtools::check_win_devel()

## Finally submit to cran
## (commented out, copy to terminal and run manually)
# devtools::release()

