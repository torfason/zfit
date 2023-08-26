
#' @description
#' `zfitter()` creates a pipe-friendly version of a fitting function of the
#' standard format –– that is a function with a `formula` parameter followed by
#' a `data` parameter. It also shortens very long data names (longer than 32
#' characters by default), which otherwise are a nuisance when the data comes
#' from the pipe, because the pipeline gets converted to a very long function
#' call.
#'
#' @examples
#' # Using zfitter to wrap around a fitting function
#' # (this is the actual way zlm_robust is defined in this package)
#' if (requireNamespace("estimatr", quietly = TRUE)) {
#'   zlm_robust <- zfitter(estimatr::lm_robust)
#'   zlm_robust(cars, speed~dist)
#'
#'   # The resulting function works well the native pipe ...
#'   if ( getRversion() >= "4.1.0" ) {
#'     cars |> zlm_robust( speed ~ dist )
#'   }
#' }
#'
#' # ... or with dplyr
#' if ( require("dplyr", warn.conflicts=FALSE) ) {
#'
#'   # Pipe cars dataset into zlm_robust for fitting
#'   cars %>% zlm_robust( speed ~ dist )
#'
#'   # Process iris with filter() before piping. Print a summary()
#'   # of the fitted model using zprint() before assigning the
#'   # model itself (not the summary) to m.
#'   m <- iris %>%
#'     dplyr::filter(Species=="setosa") %>%
#'     zlm_robust(Sepal.Length ~ Sepal.Width + Petal.Width) %>%
#'     zprint(summary)
#' }
#'
#' @rdname zfunction
#' @export
zfitter <- function(fun) {

  # zfitter() only makes sense if fun has "formula" & "data" parameters.
  # For edge cases, zfold() can always be called directly
  if ( length(setdiff(c("formula","data"), names(formals(fun)))) > 0 ) {
    stop( paste0("Specified fitting function ('",
        deparse(substitute(fun)), "') must take formula and data parameters.") )
  }

  # Call zfold() to create a fold around fun with "data" param at front
  # Use eval(bquote()) to preserve the correct name of the function
  eval(bquote( zfold(.(substitute(fun)), "data" )))
}
