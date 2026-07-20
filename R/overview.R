
overview <- function(data = NULL, print = TRUE) {
  if (is.null(data)) {
    normacro <- get_normacro()
    international <- get_international_macro()
    
    metadata_norway <- get_normacro_metadata()
    metadata_international <- get_international_metadata()
    
    result <- list(
      norway = list(
        period = range(normacro$Aar, na.rm = TRUE),
        n_observations = nrow(normacro),
        n_variables = ncol(normacro) - 1,
        n_categories = dplyr::n_distinct(metadata_norway$Kategori)
      ),
      international = list(
        period = range(international$Aar, na.rm = TRUE),
        n_observations = nrow(international),
        n_variables = ncol(international) - 2,
        n_countries = dplyr::n_distinct(international$Land),
        n_categories = dplyr::n_distinct(metadata_international$Kategori)
      )
    )
    
    if (print) {
      cat("\n")
      cat("NorMacro\n")
      cat("========\n\n")
      
      cat("Metadata-drevet rammeverk for norske og internasjonale\n")
      cat("makroøkonomiske tidsserier.\n\n")
      
      cat("Norske data\n")
      cat("-----------\n")
      cat("Periode:        ",
          result$norway$period[1],
          "-",
          result$norway$period[2],
          "\n",
          sep = "")
      cat("Observasjoner:  ",
          result$norway$n_observations,
          "\n",
          sep = "")
      cat("Variabler:      ", result$norway$n_variables, "\n", sep = "")
      cat("Kategorier:     ", result$norway$n_categories, "\n\n", sep = "")
      
      cat("Internasjonale data\n")
      cat("-------------------\n")
      cat(
        "Periode:        ",
        result$international$period[1],
        "-",
        result$international$period[2],
        "\n",
        sep = ""
      )
      cat("Observasjoner:  ",
          result$international$n_observations,
          "\n",
          sep = "")
      cat("Land:           ", result$international$n_countries, "\n", sep = "")
      cat("Variabler:      ",
          result$international$n_variables,
          "\n",
          sep = "")
      cat("Kategorier:     ",
          result$international$n_categories,
          "\n\n",
          sep = "")
      
      cat("Utforsk databasen\n")
      cat("-----------------\n")
      cat(sprintf("%-28s %s\n", "overview(normacro)", "Vis norske data"))
      cat(sprintf(
        "%-28s %s\n",
        "overview(international)",
        "Vis internasjonale data"
      ))
      cat(sprintf("%-28s %s\n", "list_categories()", "Vis alle kategorier"))
      cat(sprintf("%-28s %s\n", "search_variables()", "Søk etter variabler"))
    }
    
    return(invisible(result))
  }
  
  metadata <- get_metadata(data)
  
  variable_names <- setdiff(names(data), c("Aar", "Land"))
  
  metadata_data <- metadata |>
    dplyr::filter(.data$Variabel %in% variable_names)
  
  years <- range(data$Aar, na.rm = TRUE)
  
  categories <- metadata_data |>
    dplyr::count(.data$Kategori, name = "Antall") |>
    dplyr::arrange(.data$Kategori)
  
  dataset_name <- if ("Land" %in% names(data)) {
    "Internasjonale data"
  } else {
    "Norske data"
  }
  
  result <- list(
    dataset = dataset_name,
    period = years,
    n_observations = nrow(data),
    n_variables = length(variable_names),
    n_categories = nrow(categories),
    categories = categories
  )
  
  if (print) {
    cat("\n")
    cat(dataset_name, "\n")
    cat(strrep("=", nchar(dataset_name)), "\n\n", sep = "")
    
    cat("Makroøkonomisk database med årlige indikatorer.\n\n")
    
    cat("Dekning\n")
    cat("-------\n")
    cat("Periode:        ", years[1], "-", years[2], "\n", sep = "")
    cat("Observasjoner:  ", nrow(data), "\n", sep = "")
    cat("Variabler:      ", length(variable_names), "\n\n", sep = "")
    
    cat("Metadata\n")
    cat("--------\n")
    cat("Dokumenterte variabler i datasettet: ",
        nrow(metadata_data),
        "\n",
        sep = "")
    cat("Kategorier i datasettet:             ", nrow(categories), "\n\n", sep = "")
    
    cat("Kategorier\n")
    cat("----------\n")
    
    for (i in seq_len(nrow(categories))) {
      cat(sprintf("%-30s %3s\n", categories$Kategori[i], categories$Antall[i]))
    }
    
    cat("\n")
  }
  
  invisible(result)
}
