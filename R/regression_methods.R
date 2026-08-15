
#' @export

coef.comparison_series_regression <- function(object, ...) {
  stats::coef(object$model, ...)
  
}

#' @export

residuals.comparison_series_regression <- function(object, ...) {
  stats::residuals(object$model, ...)
  
}

#' @export

fitted.comparison_series_regression <- function(object, ...) {
  stats::fitted(object$model, ...)
  
}

#' @export

vcov.comparison_series_regression <- function(object, ...) {
  stats::vcov(object$model, ...)
  
}

#' @export

formula.comparison_series_regression <- function(x, ...) {
  stats::formula(x$model, ...)
  
}

#' @export

nobs.comparison_series_regression <- function(object, ...) {
  stats::nobs(object$model, ...)
  
}

#' @export

model.frame.comparison_series_regression <- function(formula, ...) {
  stats::model.frame(formula$model, ...)
  
}

#' @export

predict.comparison_series_regression <- function(object, ...) {
  stats::predict(object$model, ...)
  
}
