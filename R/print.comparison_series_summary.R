
print.comparison_series_summary <- function(x, ...) {
  transformation <- attr(x, "transformation")
  
  transformation_periods <- attr(x, "transformation_periods")
  
  base_year <- attr(x, "base_year")
  
  transformation_base_value <- attr(x, "transformation_base_value")
  
  transformation_label <- if (is.null(transformation)) {
    "ukjent"
  } else {
    transformation
  }
  
  cat("<comparison_series_summary>\n")
  
  cat("Serier:         ", nrow(x), "\n", sep = "")
  
  cat("Transformasjon: ", transformation_label, "\n", sep = "")
  
  if (!is.null(transformation_periods)) {
    cat("Perioder:       ", transformation_periods, "\n", sep = "")
  }
  
  if (!is.null(base_year)) {
    cat("Basisår:        ", base_year, "\n", sep = "")
  }
  
  if (!is.null(transformation_base_value)) {
    cat("Basisverdi:     ", transformation_base_value, "\n", sep = "")
  }
  
  cat("\n")
  
  print(tibble::as_tibble(x), ...)
  
  invisible(x)
}