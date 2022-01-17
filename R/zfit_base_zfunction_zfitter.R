
#' zfit: Fit Models in a Pipe
#'
#' @description
#' `r desc::desc_get("Description")`
#'
#' @includeRmd man/include/overview.Rmd
#'
#' @seealso
#' * [zlm] is the wrapper `lm`, probably the most common fitting
#'   function. The help file for this function includes several
#'   usage examples.
#' * [zglm] is a wrapper for `glm`, to fit generalized
#'   linear models.
#' * [zprint] is helpful for printing a `summary` of a model,
#'   but assigning the evaluated model to a variable
#'
#' @docType package
#' @name zfit
NULL

#' Create a safer sequence
#'
#' Internal function to create a sequence in a safe way.
#'
#' @param from Low end of sequence
#' @param to High end of sequence
#' @return A sequence from `from` to `to`, or error if `to<from`
#'
#' @md
#' @noRd
zeq <- function(from, to)
{
    stopifnot ( round(from) == from )
    stopifnot ( round(to)   == to   )
    stopifnot ( to >= from - 1      )
    return (seq_len(1+to-from)+from-1)
}

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
#' @param x The name of the argument that should be moved to the
#'   front of the argument list . The name should not be quoted.
#'
#' @examples
#'
#' char_vector <- rownames(mtcars)
#'
#' zgrep <- zfunction(grep, x)
#' grep("ll", char_vector, value=TRUE)
#' zgrep(char_vector, "ll", value=TRUE)
#'
#' @md
#' @export
zfunction <- function(fun, x) {

  # Compute the key components
  frm <- formals(fun)
  x   <- deparse(substitute(x))
  ix  <- which(names(frm)==x)
  nchar(x) > 0 || stop("argument \"x\" is missing, with no default")
  ix > 0 || stop(paste0("argument '",x,"' was not found in the parameter list of '",deparse(substitute(fun)),"()'"))

  # Rearrange the formals
  formals(fun) <- frm[c(ix, zeq(1,ix-1), zeq(ix+1,length(frm)))]

  # Return the modified function
  fun
}


# Fix R CMD check error
utils::globalVariables("data")

#' Create a pipe-friendly version of a given fitting function
#'
#' @description
#' Compared to just using `zfunction()`, this function stores the base
#' name, allowing one to use full name of the original fitting function
#' (such as `MASS::polr`), which is useful to just pull a single
#' fitting function from a package without loading it. It also shortens
#' very long data names (longer than 32 characters by default), which
#' otherwise are a nuisance when the data comes from the pipe, because
#' the pipeline gets converted to a very long function call.
#'
#' @param fun The fitting function to adapt. The name should not be quoted,
#'   rather, the actual function should be passed (prefixed with package
#'   if needed)
#'
#' @md
#' @export
zfitter <- function(fun) {

  # Ensure we were passed an actual existing function
  if ( !is.function(fun) )  {
    stop( paste0("Specified fitting function ('",
        deparse(substitute(fun)), "') was not found.") )
  }

  # Ensure the function has "formula" and "data" parameters
  if ( length(setdiff(c("formula","data"), names(formals(fun)))) > 0 ) {
    stop( paste0("Specified fitting function ('",
        deparse(substitute(fun)), "') must take formula and data parameters.") )
  }

  # Store the name of the function to call, trimming package if present
  # Assign the function to a local variable to get a clean name in output
  fun_name <- deparse(substitute(fun))
  fun_name <- gsub(".*::","",fun_name)
  assign(fun_name, fun)

  # Construct a shim, then reorder the arguments using zfunction()
  result <- function() {

    # Assign data to local variable, trimming name to "." if more than 32 chars
    data_name <- deparse(substitute(data))
    data_name <- ifelse(nchar(data_name)>32, ".", data_name)
    assign(data_name, data)

    # Get match the call, change the function
    cl <- match.call()
    cl[[1]] <- as.name(fun_name)
    eval(cl)
  }
  formals(result) <- formals(zfunction(fun,data))

  # Return the newly created function
  result
}


