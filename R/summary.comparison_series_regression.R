

summary.comparison_series_regression <- function(object, ...) {
  model_summary <- summary(object$model)
  
  coefficient_matrix <- model_summary$coefficients
  
  coefficient_table <- tibble::tibble(
    Term = rownames(coefficient_matrix),
    Estimat = unname(coefficient_matrix[, "Estimate"]),
    Standardfeil = unname(coefficient_matrix[, "Std. Error"]),
    T_verdi = unname(coefficient_matrix[, "t value"]),
    P_verdi = unname(coefficient_matrix[, "Pr(>|t|)"])
  ) |>
    dplyr::mutate(
      Signifikans = dplyr::case_when(
        .data$P_verdi < 0.001 ~ "***",
        .data$P_verdi < 0.010 ~ "**",
        .data$P_verdi < 0.050 ~ "*",
        .data$P_verdi < 0.100 ~ ".",
        TRUE ~ ""
      )
    )
  
  f_statistic <- model_summary$fstatistic
  
  if (is.null(f_statistic)) {
    f_value <- NA_real_
    numerator_degrees_of_freedom <- NA_real_
    denominator_degrees_of_freedom <- NA_real_
    f_p_value <- NA_real_
    
  } else {
    f_value <- unname(f_statistic[["value"]])
    
    numerator_degrees_of_freedom <- unname(f_statistic[["numdf"]])
    
    denominator_degrees_of_freedom <- unname(f_statistic[["dendf"]])
    
    f_p_value <- stats::pf(
      q = f_value,
      df1 = numerator_degrees_of_freedom,
      df2 = denominator_degrees_of_freedom,
      lower.tail = FALSE
    )
    
  }
  
  residual_values <- stats::residuals(object$model)
  
  residual_quantiles <- stats::quantile(
    residual_values,
    probs = c(0, 0.25, 0.50, 0.75, 1),
    na.rm = TRUE,
    names = FALSE
  )
  
  model_statistics <- tibble::tibble(
    R_kvadrert = model_summary$r.squared,
    Justert_R_kvadrert = model_summary$adj.r.squared,
    Residual_standardfeil = model_summary$sigma,
    F_verdi = f_value,
    Teller_frihetsgrader = numerator_degrees_of_freedom,
    Nevner_frihetsgrader = denominator_degrees_of_freedom,
    F_p_verdi = f_p_value,
    Modell_frihetsgrader = unname(object$model$rank),
    Residual_frihetsgrader = unname(object$model$df.residual)
  )
  
  data_statistics <- tibble::tibble(
    Tilgjengelige_perioder =
      object$number_of_candidate_observations,
    Brukte_observasjoner =
      object$number_of_observations,
    Ufullstendige_perioder =
      object$number_of_incomplete_observations,
    Estimert_startaar =
      object$estimated_start_year,
    Estimert_sluttaar =
      object$estimated_end_year,
    Oensket_startaar = if (is.null(object$requested_start_year)) {
      NA_real_
    } else {
      object$requested_start_year
    },
    Oensket_sluttaar = if (is.null(object$requested_end_year)) {
      NA_real_
    } else {
      object$requested_end_year
    }
  )
  
  residual_statistics <- tibble::tibble(
    Minimum = residual_quantiles[1],
    Foerste_kvartil = residual_quantiles[2],
    Median = residual_quantiles[3],
    Tredje_kvartil = residual_quantiles[4],
    Maksimum = residual_quantiles[5]
  )
  
  result <- list(
    regression = object,
    model = object$model,
    formula = object$formula,
    model_type = object$model_type,
    dependent_variable = object$dependent_variable,
    independent_variables = object$independent_variables,
    dependent_display_name = object$dependent_display_name,
    independent_display_names =
      object$independent_display_names,
    coefficients = coefficient_table,
    model_statistics = model_statistics,
    data_statistics = data_statistics,
    residual_statistics = residual_statistics
  )
  
  attr(result, "transformation") <- attr(object, "transformation")
  
  attr(result, "transformation_periods") <- attr(object, "transformation_periods")
  
  attr(result, "base_year") <- attr(object, "base_year")
  
  attr(result, "transformation_base_value") <- attr(object, "transformation_base_value")
  
  class(result) <- c("comparison_series_regression_summary", "list")
  
  result
}