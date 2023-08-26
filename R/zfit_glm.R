
# Fix R CMD check errors
utils::globalVariables("gaussian")
utils::globalVariables("binomial")


#' Run a glm model in a pipe
#'
#' @description
#' These functions are wrappers for the [glm] function. The `zglm` function can
#' be used to estimate any generalized linear model in a pipe. The `zlogit`,
#' `zprobit`, and `zpoisson` functions can be used to estimate specific models.
#' All of these functions rely on the `glm` function for the actual estimation,
#' they simply pass the corresponding values to the `family` parameter of the
#' `glm` function.
#'
#' Usage of these functions is very similar to the [zlm] function (a wrapper
#' for lm), for detailed examples, check out the entry for that function.
#'
#' @param data A `data.frame` containing the model data.
#' @param formula The `formula` to be fitted.
#' @param family See the `glm` function.
#' @param weights See the `glm` function.
#' @param subset See the `glm` function.
#' @param na.action See the `glm` function.
#' @param start See the `glm` function.
#' @param etastart See the `glm` function.
#' @param mustart See the `glm` function.
#' @param offset See the `glm` function.
#' @param control See the `glm` function.
#' @param model See the `glm` function.
#' @param method See the `glm` function.
#' @param x See the `glm` function.
#' @param y See the `glm` function.
#' @param singular.ok See the `glm` function.
#' @param contrasts See the `glm` function.
#' @param ... Other arguments to be passed to the `glm` function.
#'
#' @return A fitted model.
#'
#' @seealso * [zlm] is the wrapper for [lm], probably the most common fitting
#'   function. The help file for [zlm] function includes several usage examples.
#'
#' @export
zglm <- zfitter(stats::glm)


#' @description
#' The `zlogit` function calls `zglm`, specifying `family=binomial(link="logit")`.
#'
#' @name zglm
#' @export
zlogit = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    assign(deparse(substitute(data)),data)
    eval(bquote( zglm(.(substitute(data)), .(formula), family=binomial(link="logit"), ...) ))
}


#' @description
#' The `zprobit` function calls `zglm`, specifying `family=binomial(link="probit")`.
#'
#' @name zglm
#' @export
zprobit = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    assign(deparse(substitute(data)),data)
    eval(bquote( zglm(.(substitute(data)), .(formula), family=binomial(link="probit"), ...) ))
}


#' @description
#' The `zpoisson` function calls `zglm`, specifying `family="poisson"`.
#'
#' @name zglm
#' @export
zpoisson = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    assign(deparse(substitute(data)),data)
    eval(bquote( zglm(.(substitute(data)), .(formula), family="poisson", ...) ))
}
