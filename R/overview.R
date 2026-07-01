
overview <- function(data = NULL, print = TRUE) {
  metadata <- get_metadata()
  
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  years <- range(data$Aar, na.rm = TRUE)
  
  categories <- metadata |>
    dplyr::count(Kategori, name = "Antall") |>
    dplyr::arrange(Kategori)
  
  n_variables <- ncol(data) - 1
  
  result <- list(
    period = years,
    n_observations = nrow(data),
    n_variables = n_variables,
    n_categories = nrow(categories),
    categories = categories
  )
  
  if (print) {
    cat("\n")
    cat("NorMacro\n")
    cat("========\n\n")
    
    cat("Norsk makroøkonomisk database med årlige indikatorer fra\n")
    cat("SSB, NAV, Norges Bank, FRED og Yahoo Finance.\n\n")
    
    cat("Dekning\n")
    cat("-------\n")
    cat("Periode:        ", years[1], "-", years[2], "\n", sep = "")
    cat("Observasjoner:  ", nrow(data), "\n", sep = "")
    cat("Variabler:      ", n_variables, " (+ årskolonnen)\n\n", sep = "")
    
    cat("Metadata\n")
    cat("--------\n")
    cat("Dokumenterte variabler: ", nrow(metadata), "\n", sep = "")
    cat("Kategorier:             ",
        dplyr::n_distinct(metadata$Kategori),
        "\n\n",
        sep = "")
    
    cat("Kategorier\n")
    cat("----------\n")
    for (i in seq_len(nrow(categories))) {
      cat(sprintf("%-30s %3s\n", categories$Kategori[i], categories$Antall[i]))
    }
    
    cat("\n")
    cat("Utforsk databasen\n")
    cat("-----------------\n")
    cat(sprintf(
      "%-22s %s\n",
      "list_categories()",
      "Vis tilgjengelige kategorier"
    ))
    cat(sprintf(
      "%-22s %s\n",
      "list_variables()",
      "Vis tilgjengelige variabler"
    ))
    cat(sprintf("%-22s %s\n", "search_variables()", "Søk etter variabler"))
    cat(sprintf(
      "%-22s %s\n",
      "describe_variable()",
      "Vis metadata for én variabel"
    ))
    
    cat("\n")
    cat("Kom i gang\n")
    cat("----------\n")
    cat(sprintf("%-22s %s\n", "get_normacro()", "Last inn databasen"))
    
    cat("\n")
    
    invisible(
      list(
        period = years,
        n_observations = nrow(data),
        n_variables = n_variables,
        n_categories = nrow(categories),
        categories = categories
      )
    )
  }
  invisible(result)
}
