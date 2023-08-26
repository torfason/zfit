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


#' Process curly parameters
#'
#' Curly parameters are processed using NSE, unless they are encapsulated in
#' curlies `{}`, which optionally triggers standard evaluation. This function
#' is only intended to be used inside another function, and it is used in
#' a very similar way to `match.arg()`. The examples are very useful ...
#'
#' @param param The parameter to process as a curly param.
#'
#' @examples
#' # Not run automatically because curly_arg() is private
#' \dontrun{
#'   # Usage of curly_arg() compared with match.arg()
#'   curly_demo <- function(x, y = c("yes", "no")) {
#'     x <- zfit:::curly_arg(x)
#'     y <- match.arg(y)
#'     x
#'   }
#'
#'   myparam  <- "a string"
#'   myvector <- c("string 1", "string 2")
#'
#'   curly_demo(a_symbol)       # NSE ON
#'   curly_demo("a string")     # NSE disabled with "" for constant strins
#'   curly_demo({"curly-wrap"}) # NSE disabled with {}
#'   curly_demo(c("a","b"))     # NSE ON, usually not wanted, quoting preferred
#'   curly_demo({c("a","b")})   # NSE disabled with {}, allowing vectors
#'   curly_demo(myparam)        # NSE ON, even if a value exists for myparam
#'   curly_demo("myparam")      # NSE disabled, result is a string constant
#'   curly_demo({myparam})      # NSE disabled, value of myparam propagates
#'   curly_demo({myvector})     # NSE disabled, value of myvector propagates
#' }
#'
#' @keywords internal
curly_arg <- function(param) {

  # Boilerplate for processing {param}
  double_sub_symbol <- eval.parent(bquote( substitute(.(substitute(param)))))
  res <- deparse(double_sub_symbol)
  if ( (res[1] == "{"  && res[length(res)] == "}") ||
       grepl("^\".*\"$", res) ) {
    res <- param
  }
  res
}

