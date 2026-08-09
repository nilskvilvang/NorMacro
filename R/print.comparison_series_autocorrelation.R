
#' @export

print.comparison_series_autocorrelation <- function(x, ...) {
  method <- attr(x, "method")
  
  use <- attr(x, "use")
  
  lags <- attr(x, "lags")
  
  start_year <- attr(x, "start_year")
  
  end_year <- attr(x, "end_year")
  
  transformation <- attr(x, "transformation")
  
  transformation_periods <- attr(x, "transformation_periods")
  
  cat("<comparison_series_autocorrelation>\n")
  
  cat("Serier:         ", dplyr::n_distinct(x$Serie_id), "\n", sep = "")
  
  cat("Metode:         ", method, "\n", sep = "")
  
  cat("NA-h\u00e5ndtering:  ", use, "\n", sep = "")
  
  if (!is.null(transformation)) {
    cat("Transformasjon: ", transformation, "\n", sep = "")
  }
  
  if (!is.null(transformation_periods)) {
    cat("Perioder:       ", transformation_periods, "\n", sep = "")
  }
  
  if (!is.null(lags)) {
    lag_label <- if (length(lags) == 1) {
      as.character(lags)
    } else if (identical(lags, seq.int(min(lags), max(lags)))) {
      paste0(min(lags), "\u2013", max(lags))
    } else {
      paste(lags, collapse = ", ")
    }
    
    cat("Lag:            ", lag_label, "\n", sep = "")
  }
  
  if (!is.null(start_year) ||
      !is.null(end_year)) {
    period_start <- if (is.null(start_year)) {
      "f\u00f8rste tilgjengelige \u00e5r"
    } else {
      as.character(start_year)
    }
    
    period_end <- if (is.null(end_year)) {
      "siste tilgjengelige \u00e5r"
    } else {
      as.character(end_year)
    }
    
    cat("Valgt periode:  ", period_start, "\u2013", period_end, "\n", sep = "")
  }
  
  cat("\n")
  
  print(tibble::as_tibble(x), ...)
  
  invisible(x)
}
