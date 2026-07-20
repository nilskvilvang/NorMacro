
coef.comparison_series_regression <- function(object, ...) {
  stats::coef(object$model, ...)
  
}


residuals.comparison_series_regression <- function(object, ...) {
  stats::residuals(object$model, ...)
  
}


fitted.comparison_series_regression <- function(object, ...) {
  stats::fitted(object$model, ...)
  
}


vcov.comparison_series_regression <- function(object, ...) {
  stats::vcov(object$model, ...)
  
}


formula.comparison_series_regression <- function(x, ...) {
  stats::formula(x$model, ...)
  
}


nobs.comparison_series_regression <- function(object, ...) {
  stats::nobs(object$model, ...)
  
}


model.frame.comparison_series_regression <- function(formula, ...) {
  stats::model.frame(formula$model, ...)
  
}


predict.comparison_series_regression <- function(object, ...) {
  stats::predict(object$model, ...)
  
}