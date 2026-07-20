
regression_plot_data <- function(
    x
) {
  
  dependent_values <-
    x$model_data[[x$dependent_variable]]
  
  tibble::tibble(
    Aar = x$model_data$Aar,
    Faktisk = dependent_values,
    Estimert = fitted(x),
    Residual = residuals(x)
  )
  
}