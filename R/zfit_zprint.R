
#' Print the result of a function in a pipe but return original object
#'
#' Given `x` and `f`, this function prints `f(x)` before returning the original
#' `x`. It is useful in a pipe, when one wants a to print the derivative of an
#' object in the pipe but then return or assign the original object. A common
#' use case is printing the `summary() of an estimated model but then assigning
#' the original model (rather than the summary object) to a variable for further
#' processing.
#'
#' @param x An object, typically in a pipe.
#' @param f A function to be applied to `x` before printing.
#' @param ... Other arguments to be passed to `f`.
#'
#' @return The original object `x`.
#'
#' @examples
#' if (getRversion() >= "4.1.0" && require("dplyr")) {
#'
#'   # Print summary before assigning model to variable
#'   m <- lm( speed ~ dist, cars) |>
#'     zprint(summary) # prints summary(x)
#'   m                 # m is the original model object
#'
#'   # Print grouped data before filtering original
#'   cw_subset <- chickwts |>
#'     zprint(count, feed, sort=TRUE) |> # prints counts by feed
#'     filter(feed=="soybean")
#'   cw_subset # cw_subset is ungrouped, but filtered by feed
#' }
#'
#' @export
zprint = function(x, f=NULL, ...) {
  if (is.null(f)) {
    print(x)
  } else {
    print(f(x, ...))
  }
  invisible(x)
}



