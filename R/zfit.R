
#' zfit: Fit Models in a Pipe
#'
#' The goal of \code{zfit} is to improve the usage of basic model
#' fitting functions within a piped work flow, in particular when
#' passing and processing a tibble (or data.frame) using
#' \code{dplyr} and associated packages.
#'
#' @docType package
#' @name zfit
NULL


#' Run an lm model in a pipe
#'
#' This function wraps around the \code{lm} function in order to make it
#' more friendly to pipe syntax (with the data first)
#'
#' @param data A \code{data.frame} containing the model data.
#' @param formula The \code{formula} to be fitted.
#' @param ... Other arguments to be passed to the \code{lm} function.
#'
#' @return A fitted model.
#'
#' @examples
#' # Pipe cars dataset into zlm for fitting
#' cars %>% zlm( speed ~ dist )
#'
#' # Process iris with filter before piping to zlm (requires dplyr)
#' if(require("dplyr")) {
#'   iris %>%
#'     filter(Species=="setosa") %>%
#'     zlm(Sepal.Length ~ Sepal.Width + Petal.Width)
#' }
#'
#' @family zfit
#' @export
#'
zlm = function(data, formula, ...) {
    # To preserve the form of the call, data is assigned to a variable
    # with the same name as the variable passed to this function,
    # and that variable name is then used in creating the call.
    #
    # We also assign stats::lm to a local variable named lm to ensure
    # that the function will work even if the user has overridden lm()
    # in their local environment (without the call referring to stats::)
    lm <- stats::lm
    assign(deparse(substitute(data)),data)
    eval(bquote(  lm(.(formula), ..., data=.(substitute(data)))  ))
}

#' Run a glm model in a pipe (see \code{zlm})
#'
#' @param data A \code{data.frame} containing the model data.
#' @param formula The \code{formula} to be fitted.
#' @param family The \code{family} function to use for fitting the model.
#' @param ... Other arguments to be passed to the \code{glm} function.
#'
#' @return A fitted model.
#'
#' @family zfit
#' @importFrom stats gaussian
#' @export
#'
zglm = function(data, formula, family=gaussian, ...) {
    # Assign data and glm to local vars, to preserve form of call (see zlm())
    glm <- stats::glm
    assign(deparse(substitute(data)),data)
    # If family has not been set to something other than the default gaussian,
    # simply call glm without specifying a family.
    if ( deparse(substitute(family)) == "gaussian" ) {
        return(eval(bquote(  glm(.(formula), ..., data=.(substitute(data)))  )))
    }
    eval(bquote(  glm(.(formula), ..., family=.(substitute(family)), data=.(substitute(data)))  ))
}


#' Run a logit model in a pipe (see \code{zlm})
#'
#' @param data A \code{data.frame} containing the model data.
#' @param formula The \code{formula} to be fitted.
#' @param ... Other arguments to be passed to the \code{glm} function.
#'
#' @return A fitted model.
#'
#' @family zfit
#' @export
#'
zlogit = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    assign(deparse(substitute(data)),data)
    eval(bquote( zglm(.(substitute(data)), .(formula), family=binomial(link="logit"), ...) ))
}




#' Run a probit model in a pipe (see \code{zlm})
#'
#' @param data A \code{data.frame} containing the model data.
#' @param formula The \code{formula} to be fitted.
#' @param ... Other arguments to be passed to the \code{glm} function.
#'
#' @return A fitted model.
#'
#' @family zfit
#' @export
#'
zprobit = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    assign(deparse(substitute(data)),data)
    eval(bquote( zglm(.(substitute(data)), .(formula), family=binomial(link="probit"), ...) ))
}

#' Run a poisson model in a pipe (see \code{zlm})
#'
#' @param data A \code{data.frame} containing the model data.
#' @param formula The \code{formula} to be fitted.
#' @param ... Other arguments to be passed to the \code{glm} function.
#'
#' @return A fitted model.
#'
#' @family zfit
#' @export
#'
zpoisson = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    assign(deparse(substitute(data)),data)
    eval(bquote( zglm(.(substitute(data)), .(formula), family="poisson", ...) ))
}

#' Run an lm_robust model in a pipe (see \code{zlm})
#'
#' @param data A \code{data.frame} containing the model data.
#' @param formula The \code{formula} to be fitted.
#' @param ... Other arguments to be passed to the \code{lm_robust} function.
#'
#' @return A fitted model.
#'
#' @family zfit
#' @export
#'
zlm_robust = function(data, formula, ...) {
    # Assign data to local var, to preserve form of call (see zlm())
    lm_robust <- estimatr::lm_robust
    assign(deparse(substitute(data)),data)
    eval(bquote(  lm_robust(.(formula), ..., data=.(substitute(data)))  ))
}




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
#' m <- lm( speed ~ dist, cars) %>%
#'   zprint(summary) # prints summary(x)
#' m                 # m is the original model object
#'
#' if(require("dplyr")) {
#'   cw_subset <- chickwts %>%
#'     zprint(count, feed, sort=TRUE) %>% # prints counts by feed
#'     filter(feed=="soybean")
#'   cw_subset # cw_subset is ungrouped, but filtered by feed
#' }
#'
#' @family zfit
#' @export
#'
zprint = function(x, f, ...) {
    print(f(x, ...))
    return(x)
}

