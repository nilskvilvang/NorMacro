
summary_normacro <- function(data = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  metadata <- get_metadata()
  cov <- coverage(data)
  
  years <- range(data$Aar, na.rm = TRUE)
  
  result <- list(
    period = years,
    n_observations = nrow(data),
    n_variables = ncol(data) - 1,
    n_categories = dplyr::n_distinct(metadata$Kategori),
    n_original = sum(metadata$Type == "Original"),
    n_derived = sum(metadata$Type == "Beregnet"),
    sources = sort(unique(metadata$Kilde)),
    coverage = cov
  )
  
  cat("\n")
  cat("NorMacro summary\n")
  cat("================\n\n")
  
  cat("Periode:        ", years[1], "-", years[2], "\n", sep = "")
  cat("Observasjoner:  ", result$n_observations, "\n", sep = "")
  cat("Variabler:      ", result$n_variables, "\n", sep = "")
  cat("Kategorier:     ", result$n_categories, "\n", sep = "")
  cat("Originale:      ", result$n_original, "\n", sep = "")
  cat("Beregnete:      ", result$n_derived, "\n\n", sep = "")
  
  cat("Datakilder\n")
  cat("----------\n")
  for(src in result$sources){
    cat("- ", src, "\n", sep = "")
  }
  
  cat("\n")
  cat("Dekning\n")
  cat("-------\n")
  cat("Tidligste serie: ", min(cov$Startaar_data, na.rm = TRUE), "\n", sep = "")
  cat("Seneste år:      ", max(cov$Sluttaar_data, na.rm = TRUE), "\n", sep = "")
  
  cat("\n")
  
  invisible(result)
}
