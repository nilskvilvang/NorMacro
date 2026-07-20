
regression_plot_data <- function(
    x
) {
  
  dependent_values <-
    x$model_data[[x$dependent_variable]]
  
  tibble::tibble(
    Aar = unname(
      x$model_data$Aar
    ),
    Faktisk = unname(
      dependent_values
    ),
    Estimert = unname(
      fitted(
        x
      )
    ),
    Residual = unname(
      residuals(
        x
      )
    )
  )
  
}