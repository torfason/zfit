
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zfit <a href='-https://github.com/torfason/zfit/'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/zfit)](https://cran.r-project.org/package=zfit)
[![Dependencies](https://tinyverse.netlify.com/badge/zfit)](https://cran.r-project.org/package=zfit)
![CRAN downloads](https://cranlogs.r-pkg.org/badges/zfit)

<!-- badges: end -->

## Overview

The goal of `zfit` is to improve the usage of basic model fitting
functions within a piped work flow, in particular when passing and
processing a `data.frame` (or `tibble`) before passing them to `lm()` or
related functions. The problem with doing this is that the pipes pass
the data object (`data.frame`/`tibble`) as the first parameter to the
function, but the conventional estimation functions expect a formula to
be the first parameter.

This is somewhat annoying when using `magrittr` style pipe, but can be
addressed by using a trick to pass the data into a subsequent parameter
using `data=.`. With the new native pipes however, this is not possible,
and the only workaround is to construct an anonymous function for each
estimation.

To address this, this package includes functions such as `zlm()` and
`zglm()`. These are very similar to the core estimation functions such
as `lm()` and `glm()`, but expect the first argument to be a
(`data.frame`/`tibble`) rather than a formula (the formula becomes the
second argument).

The package also includes the `zprint()` function, which is intended to
simplify the printing of derived results, such as `summary()`, within
the pipe, without affecting the modeling result itself. It also includes
convenience functions for calling estimation functions using particular
parameters, including `zlogit()` and `zprobit()`, to perform logistic
regression within a pipe.

*The examples use magrittr-style (`%>%`) pipe syntax, but work in the
same way with the new native pipe syntax (`|>`).*

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
cars %>% zlm( speed ~ dist )
```

Often, it is useful to process the `data.frame`/`tibble` before passing
it to `zlm()`:

``` r
iris %>%
  filter( Species=="setosa" ) %>%
  zlm( Sepal.Length ~ Sepal.Width + Petal.Width )
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
m <- iris %>%
  filter(Species=="setosa") %>%
  zlm(Sepal.Length ~ Sepal.Width + Petal.Width) %>%
  zprint(summary)
```

The `zprint()` function is quite useful within an estimation pipeline to
print a summary of an object without returning the summary (using
`zprint(summary)` as above), but it can also be used independently from
estimation models, such as to print a summarized version of a tibble
within a pipeline before further processing, without breaking the
pipeline:

``` r
sw_subset <- starwars %>%
  zprint(count, homeworld, sort=TRUE) %>% # prints counts by homeworld
  filter(homeworld=="Tatooine")
sw_subset  # sw_subset is ungrouped, but filtered by homeworld
```
