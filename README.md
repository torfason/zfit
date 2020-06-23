
# zfit

<!-- badges: start -->
<!-- badges: end -->

The goal of `zfit` is to improve the usage of basic model fitting functions within a piped work flow, in particular when passing and processing a data.frame using `dplyr` or similar packages.

To this end, the package includes functions such as `zlm()` and `zglm()`. These are very similar to the core estimation functions such as `lm()` and `glm()`, but expect the first argument to be a tibble. 

The `zprint()` function is intended to simplify the printing of derived results, such as `summary()`, within the pipe, without affecting the modeling result itself.

The package also includes convenience functions for calling estimation functions using particular parameters, including `zlogit()` and `zprobit()`, to perform logistic regression within a pipe.

## Installation

You can install the development version of zfit from [GitHub](https://github.com/torfason/zfit) with:

``` r
remotes::install_github("torfason/zfit")
```

## Examples

The examples below assume that the following packages are loaded:

``` r
library(zfit)
library(dplyr)
```

The most basic use of the functions in this package is to pass a tibble to `zlm()`:

``` r
cars %>% zlm( speed ~ dist )
```

Often, it is useful to process the tibble before passing it to `zlm()`:

``` r
iris %>%
  filter( Species=="setosa" ) %>%
  zlm( Sepal.Length ~ Sepal.Width + Petal.Width )
```

The `zprint()` function provides a simple way to "tee" the piped object for printing a derived object, but then passing the *original* object onward through the pipe. The following code pipes an estimation model object into `zprint(summary)`. This means that the `summary()` function is called on the model being passed through the pipe, and the resulting summary is printed. However, `zprint(summary)` then returns the original model object, which is assigned to `m`  (instead of assigning the summary object):

``` r
m <- iris %>%
  filter(Species=="setosa") %>%
  zlm(Sepal.Length ~ Sepal.Width + Petal.Width) %>%
  zprint(summary)
```

The `zprint()` function is quite useful within an estimation pipeline to print a summary of an object without returning the summary (using `zprint(summary)` as above), but it can also be used independently from estimation models, such as to print a summarized version of a tibble within a pipeline before further processing, without breaking the pipeline:

``` r
sw_subset <- starwars %>%
  zprint(count, homeworld, sort=TRUE) %>% # prints counts by homeworld
  filter(homeworld=="Tatooine")
sw_subset  # sw_subset is ungrouped, but filtered by homeworld
```
