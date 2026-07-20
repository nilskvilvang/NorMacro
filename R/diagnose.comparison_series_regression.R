
Sys.setlocale(
  "LC_CTYPE",
  ".UTF-8"
)

diagnose.comparison_series_regression <- function(object, ...) {
  model_summary <-
    summary(object$model)
  
  residual_values <-
    residuals(object)
  
  residual_quantiles <-
    stats::quantile(
      residual_values,
      probs = c(0, 0.25, 0.50, 0.75, 1),
      na.rm = TRUE,
      names = FALSE
    )
  
  model_quality <-
    tibble::tibble(
      Maal = c("RMSE", "MAE", "MAPE", "Residual standard error"),
      Verdi = c(
        rmse(object),
        mae(object),
        mape(object),
        model_summary$sigma
      )
    )
  
  residual_statistics <-
    tibble::tibble(
      Statistikk = c("Minimum", "1. kvartil", "Median", "3. kvartil", "Maksimum"),
      Verdi = residual_quantiles
    )
  
  durbin_watson_statistic <-
    sum(diff(residual_values)^2) /
    sum(residual_values^2)
  
  shapiro_test <-
    stats::shapiro.test(residual_values)
  
  tests <-
    tibble::tibble(
      Test = c("Durbin-Watson", "Shapiro-Wilk"),
      Statistikk = c(durbin_watson_statistic, unname(shapiro_test$statistic)),
      P_verdi = c(NA_real_, shapiro_test$p.value)
    )
  
  diagnostic_assessment <- tibble::tibble(Type = character(),
                                          Nivaa = character(),
                                          Melding = character())
  
  durbin_watson_value <-
    tests$Statistikk[tests$Test == "Durbin-Watson"]
  
  shapiro_p_value <-
    tests$P_verdi[tests$Test == "Shapiro-Wilk"]
  
  if (!is.na(durbin_watson_value) &&
      (durbin_watson_value < 1.5 ||
       durbin_watson_value > 2.5)) {
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        tibble::tibble(
          Type = "Autokorrelasjon",
          Nivaa = "Advarsel",
          Melding = paste0(
            "Durbin-Watson-statistikken er ",
            round(durbin_watson_value, 2),
            ". Dette kan tyde på autokorrelasjon i residualene."
          )
        )
      )
    
  }
  
  if (!is.na(shapiro_p_value) &&
      shapiro_p_value < 0.05) {
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        tibble::tibble(
          Type = "Residualfordeling",
          Nivaa = "Advarsel",
          Melding = paste0(
            "Shapiro-Wilk-testen har p-verdi ",
            round(shapiro_p_value, 3),
            ". Residualene avviker muligens fra normalfordelingen."
          )
        )
      )
    
  }
  
  if (nobs(object) < 30) {
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        tibble::tibble(
          Type = "Utvalgsstørrelse",
          Nivaa = "Merknad",
          Melding = paste0(
            "Modellen er estimert med bare ",
            nobs(object),
            " observasjoner. Diagnostiske tester bør tolkes med varsomhet."
          )
        )
      )
    
  }
  
  result <-
    list(
      model_quality = model_quality,
      residual_statistics = residual_statistics,
      tests = tests,
      diagnostic_assessment = diagnostic_assessment
    )
  
  class(result) <- "comparison_series_regression_diagnosis"
  
  result
  
}