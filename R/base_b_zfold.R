
#' Create pipe-friendly fold around a function
#'
#' @description
#' The `zfold()` creates a pipe-friendly version of a function of the
#' standard format by creating a fold (or wrapper) around it with
#' the parameters reordered.
#'
#' Compared to just using `zfunction()`, which makes a copy of the original
#' function with rearranged the parameters, this function will call the original
#' function with all passed parameters. Among other things, it makes it possible
#' to make pipe-friendly versions of `S3` generics, whereas rearranging
#' parameters directly will break the `S3` dispatch mechanism.
#'
#' @param fun The function to adapt. The name should not be quoted,
#'   rather, the actual function should be passed (prefixed with package
#'   if needed)
#' @param x The name of the argument that should be moved to the front of the
#'   argument list. Can be passed with or without quotes, and is processed using
#'   non-standard evaluation unless surrounded with curlies, as in `{value}`,
#'   see details below
#' @param x_not_found How to handle the case where the value of `x` x ix not the
#'   name of a parameter in fun. If `error`, abort the function. If `ok`, prepend the value to the
#'   existing parameter list. This can be useful if looking to pipe data into a parameter that
#'   is hidden by a `...`.
#'
#' @examples
#' char_vector <- rownames(mtcars)
#' zgrep <- zfold(grep, x)
#' grep("ll", char_vector, value=TRUE)
#' zgrep(char_vector, "ll", value=TRUE)
#'
#' @md
#' @export
zfold <- function(fun, x, x_not_found = c("error", "warning", "ok")) {

  # Process and validate args
  !missing(x)      || stop("x may not be missing")
  x <- curly_arg(x) # Process curlies{}
  nchar(x) > 0     || stop("argument \"x\" is missing, with no default")
  is.function(fun) || stop( paste0("Specified function ('",
                      deparse(substitute(fun)), "') was not found.") )
  !missing(x)      || stop("x may not be missing")
  x_not_found <- match.arg(x_not_found)

  # Store the name of the function to call, trimming package if present
  fun_name <- deparse(substitute(fun))
  fun_name <- gsub(".*::", "", fun_name)

  # Construct a shim, then reorder the arguments using zfunction()
  result <- function() {

    # Assign 'fun' in 'e', a new environment that then contains both
    # 'fun' and the calling environment, parent.frame(), where other
    # variables that 'fun'  # needs are available
    e <- new.env(parent = parent.frame())
    assign(fun_name, fun, envir = e)

    # Match the call, and evaluate the function in e
    cl <- match.call()
    cl[[1]] <- as.name(fun_name)
    eval(cl, envir = e)
  }
  formals(result) <- formals(zfunction(fun, {x}, x_not_found = x_not_found))

  # Return the newly created function
  result
}
