
#' Create a pipe-friendly version of any function
#'
#' @description
#' `zfunction()` rearranges the arguments of any function moving the
#' specified argument to the front of the list, so that this argument
#' becomes the recipient of piping.
#'
#' It returns a copy of the input function, that is completely
#' identical except for the order of the arguments.
#'
#' @param fun The function to adapt. The name should not be quoted,
#'   rather, the actual function should be passed (prefixed with package
#'   if needed).
#' @param x The name of the argument that should be moved to the front of the
#'   argument list. Can be passed with or without quotes, and is processed using
#'   non-standard evaluation unless surrounded with curlies, as in `{value}`,
#'   see details below
#' @param x_not_found How to handle the case where the value of `x` x ix not the
#'   name of a parameter in fun. If `error`, abort the function. If `ok`, prepend the value to the
#'   existing parameter list. This can be useful if looking to pipe data into a parameter that
#'   is hidden by a `...`.
#'
#' @details
#' The `x` parameter is processed using non-standard evaluation, which can be
#' disabled using curly brackets. In other words, the following are all
#' equivalent, and return a file renaming function with the `to` parameter as
#' the first one:
#'
#'   * `zfunction(file.rename, to)`
#'   * `zfunction(file.rename, "to")`
#'   * `param_name <- "to"; zfunction(file.rename, {param_name})`
#'
#' @examples
#'
#' char_vector <- rownames(mtcars)
#'
#' # A a grep function with x as first param is often useful
#' zgrep <- zfunction(grep, x)
#' grep("ll", char_vector, value=TRUE)
#' zgrep(char_vector, "ll", value=TRUE)
#'
#' # plsr hides the data parameter behind the ...
#' if (requireNamespace("pls")) {
#'   zplsr <- zfunction(pls::plsr, data, x_not_found = "ok")
#'   zplsr(cars, dist ~ speed)
#' }
#'
#' # Curly {x} handling: These are all equivalent
#' param_name <- "to";
#' f1 <- zfunction(file.rename, to)
#' f2 <- zfunction(file.rename, "to")
#' f3 <- zfunction(file.rename, {param_name})
#'
#' @md
#' @export
zfunction <- function(fun, x, x_not_found = c("error", "warning", "ok")) {

  # Process and validate args
  !missing(x)      || stop("x may not be missing")
  x <- curly_arg(x) # Process curlies{}
  nchar(x) > 0     || stop("argument \"x\" is missing, with no default")
  is.function(fun) || stop( paste0("Specified function ('",
                      deparse(substitute(fun)), "') was not found.") )
  x_not_found <- match.arg(x_not_found)
  frm <- formals(fun)
  ix  <- which(names(frm)==x)

  # Rearrange the formals
  if (length(ix) > 0) {
    # x found in the parameter list, move to front
    formals(fun) <- frm[c(ix, zeq(1,ix-1), zeq(ix+1,length(frm)))]
  } else {
    msg <- paste0("'", x, "' not found in the parameter list of '",
                  deparse(substitute(fun)), "()'")
    if (x_not_found == "error") {
      stop(msg)
    } else if (x_not_found == "warning") {
      warning(msg)
    }
    # x not found in the parameter list (but no error thrown)
    # Add x to front of the list
    pl <- alist(x_tmp=); names(pl)[1] <- x
    formals(fun) <- c(pl, frm)
  }

  # Return the modified function
  fun
}
