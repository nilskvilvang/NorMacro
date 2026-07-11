
overview <- function(data = NULL, print = TRUE) {
  
  metadata <- get_metadata(data)
  
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  variable_names <- setdiff(names(data), c("Aar", "Land"))
  
  metadata_data <- metadata |>
    dplyr::filter(Variabel %in% variable_names)
  
  years <- range(data$Aar, na.rm = TRUE)
  
  categories <- metadata_data |>
    dplyr::count(Kategori, name = "Antall") |>
    dplyr::arrange(Kategori)
  
  result <- list(
    period = years,
    n_observations = nrow(data),
    n_variables = length(variable_names),
    n_categories = nrow(categories),
    categories = categories
  )
  
  if (print) {
    cat("\n")
    cat("NorMacro\n")
    cat("========\n\n")
    
    cat("Makroøkonomisk database med årlige indikatorer.\n\n")
    
    cat("Dekning\n")
    cat("-------\n")
    cat("Periode:        ", years[1], "-", years[2], "\n", sep = "")
    cat("Observasjoner:  ", nrow(data), "\n", sep = "")
    cat("Variabler:      ", length(variable_names), "\n\n", sep = "")
    
    cat("Metadata\n")
    cat("--------\n")
    cat("Dokumenterte variabler i datasettet: ", nrow(metadata_data), "\n", sep = "")
    cat("Kategorier i datasettet:             ", nrow(categories), "\n\n", sep = "")
    
    cat("Kategorier\n")
    cat("----------\n")
    for (i in seq_len(nrow(categories))) {
      cat(sprintf("%-30s %3s\n", categories$Kategori[i], categories$Antall[i]))
    }
    
    cat("\n")
    cat("Utforsk databasen\n")
    cat("-----------------\n")
    cat(sprintf("%-22s %s\n", "list_categories(data)", "Vis tilgjengelige kategorier"))
    cat(sprintf("%-22s %s\n", "list_variables(data)", "Vis tilgjengelige variabler"))
    cat(sprintf("%-22s %s\n", "search_variables()", "Søk etter variabler"))
    cat(sprintf("%-22s %s\n", "describe_variable()", "Vis metadata for én variabel"))
    
    cat("\n")
    
    invisible(result)
  }
  
  invisible(result)
}
