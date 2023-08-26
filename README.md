
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zfit <a href='https://github.com/torfason/zfit/'><img src='man/figures/logo.png' align="right" width="140px" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/zfit)](https://cran.r-project.org/package=zfit)
[![CRAN status
shields](https://img.shields.io/badge/Git-0.3.0.9001-success)](https://github.com/torfason/zmisc)
[![R-CMD-check](https://github.com/torfason/zfit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/torfason/zfit/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## TL;DR

If you are tired of doing the following:

``` r
dat <- mtcars |>
  filter(am == 1)
lm(mpg ~ wt + hp, data=dat)
```

and would like to do this instead:

``` r
mtcars |> 
  filter(am == 1) |>
  zlm(mpg ~ wt + hp)
```

then this little package might be something for you.

## Overview

`zfit` makes it easier to use a piped workflow with functions that don’t
have the “correct” order of parameters (the first parameter of the
function does not match the object passing through the pipe).

The issue is especially prevalent with model fitting functions, such as
when passing and processing a `data.frame` (or `tibble`) before passing
them to `lm()` or similar functions. The pipe passes the data object
into the first parameter of the function, but the conventional
estimation functions expect a formula to be the first parameter.

This package addresses the issue with three functions that make it
trivial to construct a pipe-friendly version of any function:

- `zfunction()` reorders the arguments of a function. Just pass the name
  of a function, and the name of the parameter that should receive the
  piped argument, and it returns a version of the function with that
  parameter coming first.

- `zfold()` creates a fold (a wrapper) around a function with the
  reordered arguments. This is sometimes needed instead of a simple
  reordering, for example for achieving correct S3 dispatch, and for
  functions that report its name or other information in output.

- `zfitter()` takes any estimation function with the standard format of
  a `formula` and `data` parameter, and returns a version suitable for
  us in pipes (with the `data` parameter coming first). Internally, it
  simply calls the `zfold()` function to create a fold around the fitter
  function.

The package also includes ready made wrappers around the most commonly
used estimation functions. `zlm()`and `zglm()` correspond to `lm()` and
`glm()`, and `zlogit()`, `zprobit()`, and `zpoisson()`, use `glm()` to
perform logistic or poisson regression within a pipe.

Finally, the package includes the `zprint()` function, which is intended
to simplify the printing of derived results, such as `summary()`, within
the pipe, without affecting the modeling result itself.

## Installation

Install the release version from
[CRAN](https://CRAN.R-project.org/package=zfit) with:

``` r
install.packages("zfit")
```

Install the development version from
[GitHub](https://github.com/torfason/zfit) with:

``` r
remotes::install_github("torfason/zfit")
```

## Examples

The examples below assume that the following packages are loaded:

``` r
library(zfit)
library(dplyr)
```

The most basic use of the functions in this package is to pass a
`data.frame`/`tibble` to `zlm()`:

``` r
cars |> zlm(speed ~ dist)
```

Often, it is useful to process the `data.frame`/`tibble` before passing
it to `zlm()`:

``` r
iris |>
  filter(Species=="setosa") |>
  zlm(Sepal.Length ~ Sepal.Width + Petal.Width)
```

The `zprint()` function provides a simple way to “tee” the piped object
for printing a derived object, but then passing the *original* object
onward through the pipe. The following code pipes an estimation model
object into `zprint(summary)`. This means that the `summary()` function
is called on the model being passed through the pipe, and the resulting
summary is printed. However, `zprint(summary)` then returns the original
model object, which is assigned to `m` (instead of assigning the summary
object):

``` r
m <- iris |>
  filter(Species=="setosa") |>
  zlm(Sepal.Length ~ Sepal.Width + Petal.Width) |>
  zprint(summary)
```

The `zprint()` function is quite useful within an estimation pipeline to
print a summary of an object without returning the summary (using
`zprint(summary)` as above), but it can also be used independently from
estimation models, such as to print a summarized version of a tibble
within a pipeline before further processing, without breaking the
pipeline:

``` r
sw_subset <- starwars |>
  zprint(count, homeworld, sort=TRUE) |> # prints counts by homeworld
  filter(homeworld=="Tatooine")
sw_subset  # sw_subset is ungrouped, but filtered by homeworld
```
