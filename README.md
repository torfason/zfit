
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zfit <a href='https://github.com/torfason/zfit/'><img src='man/figures/logo.png' align="right" width="140px" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/zfit)](https://cran.r-project.org/package=zfit)
[![Dependencies](https://tinyverse.netlify.com/badge/zfit)](https://cran.r-project.org/package=zfit)
![CRAN downloads](https://cranlogs.r-pkg.org/badges/zfit)

<!-- badges: end -->

## TL;DR

If you are tired of doing the following:

``` r
dat <- mtcars %>%
  filter( am==1 )
lm( mpg ~ wt + hp, data=dat )
```

and would like to do this instead:

``` r
mtcars %>%
  filter( am==1 ) %>%
  zlm( mpg ~ wt + hp )
```

then this little package might be something for you.

## Overview

The goal of `zfit` is to make it easier to use a piped workflow with
functions that don’t have the “correct” order of parameters (the first
parameter of the function does not match the object passing through the
pipe). This issue is especially prevalent with model fitting functions,
such as when passing and processing a `data.frame` (or `tibble`) before
passing them to `lm()` or similar functions. The pipe passes the data
object (`data.frame`/`tibble`) into the first parameter of the function,
but the conventional estimation functions expect a formula to be the
first parameter.

When using `magrittr` style pipes (`%>%`), this can be addressed by
using special syntax, specifying `data=.` to pass the piped data into a
parameter other than the first one. With R native pipes (`|>`), however,
this is not possible and workaround are needed (such as constructing an
anonymous function for each estimation or relying on complex rules about
how piped arguments are interpreted in the presence of named
parameters).

To address this, this package includes functions such as
[zlm()](https://torfason.github.io/zfit/reference/zlm.html) and
[zglm()](https://torfason.github.io/zfit/reference/zglm.html). These are
very similar to the core estimation functions such as `lm()` and
`glm()`, but expect the first argument to be a (`data.frame`/`tibble`)
rather than a formula (the formula becomes the second argument).

More importantly, the package includes two functions that make it
trivial to construct a pipe-friendly version of any function. The
[zfitter()](https://torfason.github.io/zfit/reference/zfitter.html)
function takes any estimation function with the standard format of a
`formula` and `data` parameter, and returns a version suitable for us in
pipes (with the `data` parameter coming first). The
[zfitter()](https://torfason.github.io/zfit/reference/zfitter.html)
function also does some special handling to make make the call
information more useful.

The
[zfunction()](https://torfason.github.io/zfit/reference/zfunction.html)
works for any function but omits the special handling for call
parameters. Just pass the name of a function, and the name of the
parameter that should receive the piped argument, and it returns a
version of the function with that parameter coming first.

The package also includes the
[zprint()](https://torfason.github.io/zfit/reference/zprint.html)
function, which is intended to simplify the printing of derived results,
such as `summary()`, within the pipe, without affecting the modeling
result itself. It also includes convenience functions for calling
estimation functions using particular parameters, including
[zlogit()](https://torfason.github.io/zfit/reference/zglm.html) and
[zprobit()](https://torfason.github.io/zfit/reference/zglm.html), and
[zpoisson()](https://torfason.github.io/zfit/reference/zglm.html), to
perform logistic or poisson regression within a pipe.

*Note that some of the examples provided in the help and documentation
use magrittr-style (`%>%`) pipe syntax, while others use the native pipe
syntax (`|>`). The package has been tested with both types of pipe
functionality and the results are identical, apart from the fact that
`%>%` renames the piped argument to `.`, whereas the name of the piped
argument is the complete nested function syntax of the pipe.*

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
