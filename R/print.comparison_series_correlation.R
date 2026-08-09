
#' @export

print.comparison_series_correlation <- function(x, ...) {
  method <- attr(x, "method")
  
  start_year <- attr(x, "start_year")
  
  end_year <- attr(x, "end_year")
  
  transformation <- attr(x, "transformation")
  
  transformation_periods <- attr(x, "transformation_periods")
  
  include_diagonal <- attr(x, "include_diagonal")
  
  transformation_label <- if (is.null(transformation)) {
    "ukjent"
  } else {
    transformation
  }
  
  cat("<comparison_series_correlation>\n")
  
  cat("Metode:         ", method, "\n", sep = "")
  
  cat("Transformasjon: ", transformation_label, "\n", sep = "")
  
  if (!is.null(transformation_periods)) {
    cat("Perioder:       ", transformation_periods, "\n", sep = "")
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
  
  cat("Diagonal:       ", if (isTRUE(include_diagonal)) {
    "inkludert"
  } else {
    "ikke inkludert"
  }, "\n", sep = "")
  
  cat("Seriepar:       ", nrow(x), "\n\n", sep = "")
  
  print(tibble::as_tibble(x), ...)
  
  invisible(x)
}
