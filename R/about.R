
about <- function(data = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  metadata <- get_metadata()
  
  years <- range(data$Aar, na.rm = TRUE)
  
  cat("\n")
  cat("NorMacro\n")
  cat("========\n\n")
  cat("Kuratert makroøkonomisk database for Norge.\n\n")
  
  cat("Dekning\n")
  cat("-------\n")
  cat("Periode:     ", years[1], "-", years[2], "\n", sep = "")
  cat("Rader:       ", nrow(data), "\n", sep = "")
  cat("Variabler:   ", ncol(data) - 1, " (+ Aar)\n", sep = "")
  cat("Kategorier:  ", dplyr::n_distinct(metadata$Kategori), "\n\n", sep = "")
  
  cat("Datakilder\n")
  cat("----------\n")
  for(kilde in sort(unique(metadata$Kilde))){
    cat("- ", kilde, "\n", sep = "")
  }
  
  cat("\n")
  cat("Kvalitet\n")
  cat("--------\n")
  validate_metadata(metadata)
  check_metadata(data)
  
  cat("\n")
  cat("Nyttige funksjoner\n")
  cat("------------------\n")
  cat("overview()\n")
  cat("coverage()\n")
  cat("leading_indicators()\n")
  cat("conjuncture_dashboard()\n")
  cat("plot_series(\"BNP_Fastland\")\n\n")
  
  invisible(
    list(
      period = years,
      n_observations = nrow(data),
      n_variables = ncol(data) - 1,
      n_categories = dplyr::n_distinct(metadata$Kategori),
      sources = sort(unique(metadata$Kilde))
    )
  )
}