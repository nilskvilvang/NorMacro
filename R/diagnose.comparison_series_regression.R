
#' @export
diagnose.comparison_series_regression <- function(object, ...) {
  
  model_summary <-
    summary(object$model)
  
  residual_values <-
    residuals(object)
  
  residual_values <-
    residual_values[
      is.finite(residual_values)
    ]
  
  residual_quantiles <-
    stats::quantile(
      residual_values,
      probs = c(
        0,
        0.25,
        0.50,
        0.75,
        1
      ),
      na.rm = TRUE,
      names = FALSE
    )
  
  # ------------------------------------------------------------
  # Modellkvalitet
  # ------------------------------------------------------------
  
  model_quality <-
    tibble::as_tibble(
      stats::setNames(
        list(
          c(
            "RMSE",
            "MAE",
            "MAPE",
            "Residual standard error"
          ),
          c(
            rmse(object),
            mae(object),
            mape(object),
            model_summary$sigma
          )
        ),
        c(
          "M\u00e5l",
          "Verdi"
        )
      )
    )
  
  # ------------------------------------------------------------
  # Residualstatistikk
  # ------------------------------------------------------------
  
  residual_statistics <-
    tibble::tibble(
      Statistikk = c(
        "Minimum",
        "1. kvartil",
        "Median",
        "3. kvartil",
        "Maksimum"
      ),
      Verdi = residual_quantiles
    )
  
  residual_sum_of_squares <-
    sum(
      residual_values^2
    )
  
  durbin_watson_statistic <-
    if (
      length(residual_values) < 2L ||
      residual_sum_of_squares == 0
    ) {
      NA_real_
    } else {
      sum(
        diff(residual_values)^2
      ) /
        residual_sum_of_squares
    }
  
  shapiro_test <-
    if (
      length(residual_values) >= 3L &&
      length(residual_values) <= 5000L &&
      length(unique(residual_values)) > 1L
    ) {
      stats::shapiro.test(
        residual_values
      )
    } else {
      NULL
    }
  
  shapiro_statistic <-
    if (is.null(shapiro_test)) {
      NA_real_
    } else {
      unname(
        shapiro_test$statistic
      )
    }
  
  shapiro_p_value <-
    if (is.null(shapiro_test)) {
      NA_real_
    } else {
      shapiro_test$p.value
    }
  
  tests <-
    tibble::tibble(
      Test = c(
        "Durbin-Watson",
        "Shapiro-Wilk"
      ),
      Statistikk = c(
        durbin_watson_statistic,
        shapiro_statistic
      ),
      P_verdi = c(
        NA_real_,
        shapiro_p_value
      )
    )
  
  # ------------------------------------------------------------
  # Diagnostisk vurdering
  # ------------------------------------------------------------
  
  diagnostic_assessment <-
    tibble::as_tibble(
      stats::setNames(
        list(
          character(),
          character(),
          character()
        ),
        c(
          "Type",
          "Niv\u00e5",
          "Melding"
        )
      )
    )
  
  make_assessment_row <- function(
    type,
    level,
    message
  ) {
    
    tibble::as_tibble(
      stats::setNames(
        list(
          type,
          level,
          message
        ),
        c(
          "Type",
          "Niv\u00e5",
          "Melding"
        )
      )
    )
  }
  
  if (is.na(durbin_watson_statistic)) {
    
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        make_assessment_row(
          type = "Autokorrelasjon",
          level = "Merknad",
          message = paste0(
            "Durbin-Watson-statistikken kunne ikke beregnes ",
            "for denne modellen."
          )
        )
      )
  }
  
  if (is.null(shapiro_test)) {
    
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        make_assessment_row(
          type = "Residualfordeling",
          level = "Merknad",
          message = paste0(
            "Shapiro-Wilk-testen kunne ikke gjennomf\u00f8res. ",
            "Testen krever mellom 3 og 5000 varierende residualer."
          )
        )
      )
  }
  
  if (
    !is.na(durbin_watson_statistic) &&
    (
      durbin_watson_statistic < 1.5 ||
      durbin_watson_statistic > 2.5
    )
  ) {
    
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        make_assessment_row(
          type = "Autokorrelasjon",
          level = "Advarsel",
          message = paste0(
            "Durbin-Watson-statistikken er ",
            round(
              durbin_watson_statistic,
              2
            ),
            ". Dette kan tyde p\u00e5 autokorrelasjon i residualene."
          )
        )
      )
  }
  
  if (
    !is.na(shapiro_p_value) &&
    shapiro_p_value < 0.05
  ) {
    
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        make_assessment_row(
          type = "Residualfordeling",
          level = "Advarsel",
          message = paste0(
            "Shapiro-Wilk-testen har p-verdi ",
            round(
              shapiro_p_value,
              3
            ),
            ". Residualene avviker muligens fra normalfordelingen."
          )
        )
      )
  }
  
  if (nobs(object) < 30L) {
    
    diagnostic_assessment <-
      dplyr::bind_rows(
        diagnostic_assessment,
        make_assessment_row(
          type = "Utvalgsst\u00f8rrelse",
          level = "Merknad",
          message = paste0(
            "Modellen er estimert med bare ",
            nobs(object),
            " observasjoner. Diagnostiske tester b\u00f8r tolkes med varsomhet."
          )
        )
      )
  }
  
  # ------------------------------------------------------------
  # Resultat
  # ------------------------------------------------------------
  
  result <-
    list(
      model_quality = model_quality,
      residual_statistics = residual_statistics,
      tests = tests,
      diagnostic_assessment = diagnostic_assessment
    )
  
  class(result) <-
    "comparison_series_regression_diagnosis"
  
  result
}
