
print.comparison_series <- function(x, ...) {
  required_columns <- c("Aar", "Serie_id", "Land", "Display_navn")
  
  if (!all(required_columns %in% names(x))) {
    return(NextMethod("print"))
  }
  
  n_series <- dplyr::n_distinct(x$Serie_id)
  n_obs <- nrow(x)
  countries <- unique(x$Land)
  period <- range(x$Aar, na.rm = TRUE)
  
  series <- x |>
    dplyr::distinct(Serie_id, Display_navn)
  
  cat("\n")
  cat("comparison_series\n")
  cat("=================\n\n")
  
  cat("Periode\n")
  cat("-------\n")
  cat(period[1], "-", period[2], "\n\n")
  
  cat("Omfang\n")
  cat("------\n")
  cat("Serier:        ", n_series, "\n", sep = "")
  cat("Observasjoner: ", n_obs, "\n\n", sep = "")
  
  cat("Land\n")
  cat("----\n")
  cat(paste(countries, collapse = ", "), "\n\n")
  
  cat("Serier\n")
  cat("-------\n")
  
  for (i in seq_len(nrow(series))) {
    cat(sprintf("%-25s %s\n", series$Serie_id[i], series$Display_navn[i]))
  }
  
  invisible(x)
}
