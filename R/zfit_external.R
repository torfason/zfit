
# Small wrapper to prepare the missing package message
msg_pkg_missing <- function(fun, pkg) {
  paste0( "'", fun, "' requires the '", pkg, "' package.\n",
          "  Install with install.packages(\"", pkg, "\") and restart R.")
}


#' Pipe-friendly wrappers for external fitters
#'
#' @description
#' These functions provide pipe-friendly wrappers around model fitters provided
#' by several external packages. The functions require the corresponding
#' packages to be installed, if the required package is missing the functions
#' warns with directions for how to install it.
#'
#' `zlm_robust()` wraps [estimatr::lm_robust()], which fits a linear model with
#' a variety of options for estimating robust standard errors.
#'
#' @examples
#' if (requireNamespace("estimatr") && getRversion() >= "4.1.0")
#'   zlm_robust(cars, dist ~ speed) |> summary() |> try()
#'
#' @name zlm_robust
#' @rdname external_fitters
#' @export
if (requireNamespace("estimatr", quietly = TRUE)) {
  zlm_robust <- zfitter(estimatr::lm_robust)
} else {
  zlm_robust <- function(...) {
    stop(msg_pkg_missing("zlm_robust()", "estimatr"))
  }
}


#' @description
#' `zpolr()` wraps [MASS::polr()], which fits an ordered logistic response for
#' multi-value ordinal variables, using a proportional odds logistic regression.
#'
#' @examples
#' if (requireNamespace("MASS") && getRversion() >= "4.1.0")
#'   zpolr(mtcars, ordered(gear) ~ mpg + hp) |> summary() |> try()
#'
#' @name zpolr
#' @rdname external_fitters
#' @export
if (requireNamespace("MASS", quietly = TRUE)) {
  zpolr <- zfitter(MASS::polr)
} else {
  zpolr <- function(...) {
    stop(msg_pkg_missing("zpolr()", "MASS"))
  }
}


#' @description
#' `zplsr()` wraps [pls::plsr()], which performs a partial least squares
#' regression.
#'
#' @examples
#' if (requireNamespace("pls") && getRversion() >= "4.1.0")
#'   zplsr(cars, dist ~ speed) |> summary() |> try()
#'
#' @name zplsr
#' @rdname external_fitters
#' @export
if (requireNamespace("pls", quietly = TRUE)) {
  zplsr <- zfunction(pls::plsr, x = "data", x_not_found = "ok")
} else {
  zplsr <- function(...) {
    stop(msg_pkg_missing("zplsr()", "pls"))
  }
}
