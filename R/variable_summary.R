
variable_summary <- function(
    variable,
    data = NULL,
    correlation_variables = NULL,
    top_n_correlations = 5
){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  if(!variable %in% names(data)){
    stop("Fant ikke variabelen i datasettet: ", variable)
  }
  
  metadata <- get_metadata()
  
  meta <- metadata |>
    dplyr::filter(Variabel == variable)
  
  cov <- coverage(data) |>
    dplyr::filter(Variabel == variable)
  
  latest <- latest_observations(data = data) |>
    dplyr::filter(Variabel == variable)
  
  growth <- growth_table(
    variables = variable,
    data = data,
    periods = c(1, 5, 10)
  )
  
  if(is.null(correlation_variables)){
    numeric_vars <- names(data)[
      vapply(data, is.numeric, logical(1))
    ]
    
    correlation_variables <- setdiff(numeric_vars, c("Aar", variable))
  }
  
  correlation_variables <- intersect(
    correlation_variables,
    names(data)
  )
  
  correlations <- NULL
  
  if(length(correlation_variables) > 0){
    
    corr_vars <- c(variable, correlation_variables)
    
    corr <- correlation_matrix(
      variables = corr_vars,
      data = data
    )
    
    correlations <- tibble::tibble(
      Variabel = rownames(corr),
      Korrelasjon = as.numeric(corr[, variable])
    ) |>
      dplyr::filter(Variabel != variable) |>
      dplyr::filter(!is.na(Korrelasjon)) |>
      dplyr::mutate(
        Absolutt_korrelasjon = abs(Korrelasjon)
      ) |>
      dplyr::arrange(dplyr::desc(Absolutt_korrelasjon)) |>
      dplyr::slice_head(n = top_n_correlations) |>
      dplyr::select(Variabel, Korrelasjon)
  }
  
  cat("\n")
  cat("Variabel\n")
  cat("--------\n")
  cat(variable, "\n\n")
  
  if(nrow(meta) > 0){
    cat("Beskrivelse\n")
    cat("-----------\n")
    cat(meta$Beskrivelse[1], "\n\n")
    
    cat("Metadata\n")
    cat("--------\n")
    cat("Kategori: ", meta$Kategori[1], "\n", sep = "")
    cat("Type:     ", meta$Type[1], "\n", sep = "")
    cat("Kilde:    ", meta$Kilde[1], "\n", sep = "")
    cat("Enhet:    ", meta$Enhet[1], "\n", sep = "")
    cat("Frekvens: ", meta$Frekvens[1], "\n\n", sep = "")
  }
  
  if(nrow(cov) > 0){
    cat("Dekning\n")
    cat("-------\n")
    cat(
      cov$Startaar_data[1],
      "-",
      cov$Sluttaar_data[1],
      "\n",
      sep = ""
    )
    cat("Observasjoner: ", cov$Antall_observasjoner[1], "\n\n", sep = "")
  }
  
  if(nrow(latest) > 0){
    cat("Siste observasjon\n")
    cat("-----------------\n")
    cat("År:    ", latest$Siste_aar[1], "\n", sep = "")
    cat("Verdi: ", latest$Siste_verdi[1], "\n\n", sep = "")
  }
  
  cat("Vekst\n")
  cat("-----\n")
  print(
    growth |>
      dplyr::select(
        Variabel,
        Siste_aar,
        Siste_verdi,
        dplyr::starts_with("Vekst_"),
        dplyr::starts_with("CAGR_")
      )
  )
  
  if(!is.null(correlations) && nrow(correlations) > 0){
    cat("\n")
    cat("Sterkeste korrelasjoner\n")
    cat("-----------------------\n")
    print(correlations)
  }
  
  invisible(
    list(
      metadata = meta,
      coverage = cov,
      latest = latest,
      growth = growth,
      correlations = correlations
    )
  )
}
