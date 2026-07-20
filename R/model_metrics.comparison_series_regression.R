
rmse.comparison_series_regression <- function(object, ...) {
  residual_values <-
    residuals(object)
  
  sqrt(mean(residual_values^2, na.rm = TRUE))
  
}


mae.comparison_series_regression <- function(object, ...) {
  residual_values <-
    residuals(object)
  
  mean(abs(residual_values), na.rm = TRUE)
  
}


mape.comparison_series_regression <- function(object, ...) {
  augmented_data <-
    broom::augment(object)
  
  valid_observations <-
    !is.na(augmented_data$Faktisk) &
    !is.na(augmented_data$Estimert) &
    augmented_data$Faktisk != 0
  
  if (!any(valid_observations)) {
    return(NA_real_)
    
  }
  
  mean(abs(
    (augmented_data$Faktisk[valid_observations] -
       augmented_data$Estimert[valid_observations]) /
      augmented_data$Faktisk[valid_observations]
  )) * 100
  
}