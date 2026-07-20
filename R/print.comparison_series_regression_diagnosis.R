
print.comparison_series_regression_diagnosis <- function(x, digits = 3, ...) {
  cat("<comparison_series_regression_diagnosis>\n\n")
  
  cat("MODELLKVALITET\n\n")
  
  model_quality <-
    x$model_quality
  
  model_quality$Verdi <-
    round(model_quality$Verdi, digits = digits)
  
  print(model_quality)
  
  cat("\nRESIDUALSTATISTIKK\n\n")
  
  residual_statistics <-
    x$residual_statistics
  
  residual_statistics$Verdi <-
    round(residual_statistics$Verdi, digits = digits)
  
  print(residual_statistics)
  
  cat("\nTESTER\n\n")
  
  tests <-
    x$tests
  
  tests$Statistikk <-
    round(tests$Statistikk, digits = digits)
  
  tests$P_verdi <-
    round(tests$P_verdi, digits = digits)
  
  print(tests)
  
  cat("\nVURDERING\n\n")
  
  diagnostic_assessment <-
    x$diagnostic_assessment
  
  if (is.null(diagnostic_assessment) ||
      nrow(diagnostic_assessment) == 0L) {
    cat("Ingen tydelige diagnostiske problemer funnet.\n")
    
  } else {
    print(diagnostic_assessment)
    
  }
  
  invisible(x)
}