
#' Print the result of a function in a pipe but return original object
#'
#' This function passes \code{x} to \code{f} and prints the result, but then
#' returns the original \code{x}. It is useful in a pipe, when one wants a
#' to print the derivative of an object in the pipe but then return or assign
#' the original object. An example is printing the \code{summary()} of an
#' estimated model but
#'
#' @param x An object, typically in a pipe
#' @param f A function to be applied to \code{x} before printing
#' @param ... Other arguments to be passed to \code{f}
#'
#' @return The original object \code{x}
#'
#' @examples
#'
#' if ( require("dplyr", warn.conflicts=FALSE) ) {
#'
#'   # Print summary before assigning model to variable
#'   m <- lm( speed ~ dist, cars) %>%
#'     zprint(summary) # prints summary(x)
#'   m                 # m is the original model object
#'
#'   # Print grouped data before filtering original
#'   cw_subset <- chickwts %>%
#'     zprint(count, feed, sort=TRUE) %>% # prints counts by feed
#'     filter(feed=="soybean")
#'   cw_subset # cw_subset is ungrouped, but filtered by feed
#' }
#'
#' @export
#'
zprint = function(x, f=NULL, ...) {
  if (is.null(f)) {
    print(x)
  } else {
    print(f(x, ...))
  }
  invisible(x)
}



