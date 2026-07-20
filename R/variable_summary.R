

variable_summary <- function(variable,
                             data = NULL,
                             country = NULL,
                             metadata = NULL,
                             correlation_variables = NULL,
                             top_n_correlations = 5) {
  if (!is.character(variable) ||
      length(variable) != 1L ||
      is.na(variable) ||
      variable == "") {
    stop("`variable` må være navnet på én gyldig variabel.", call. = FALSE)
  }
  
  if (!is.null(country)) {
    if (!is.character(country) ||
        length(country) != 1L ||
        is.na(country) ||
        country == "") {
      stop("`country` må være én gyldig landkode.", call. = FALSE)
    }
  }
  
  if (!is.numeric(top_n_correlations) ||
      length(top_n_correlations) != 1L ||
      is.na(top_n_correlations) ||
      top_n_correlations < 1) {
    stop("`top_n_correlations` må være et positivt heltall.", call. = FALSE)
  }
  
  top_n_correlations <-
    as.integer(top_n_correlations)
  
  if (is.null(data)) {
    if (is.null(country)) {
      data <-
        suppressMessages(get_normacro())
    } else {
      data <-
        suppressMessages(get_international_macro())
    }
  }
  
  if (!is.data.frame(data)) {
    stop("`data` må være et datasett.", call. = FALSE)
  }
  
  has_country_column <-
    "Land" %in% names(data)
  
  is_international <-
    has_country_column ||
    !is.null(country)
  
  if (has_country_column) {
    if (is.null(country)) {
      stop(
        paste0(
          "Datasettet inneholder flere land. ",
          "Angi ett land med argumentet `country`."
        ),
        call. = FALSE
      )
    }
    
    available_countries <-
      data$Land |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    if (!country %in% available_countries) {
      stop("Fant ikke landet i datasettet: ", country, call. = FALSE)
    }
    
    data <-
      data |>
      dplyr::filter(.data$Land == country) |>
      dplyr::select(-dplyr::all_of("Land"))
  }
  
  if (!"Aar" %in% names(data)) {
    stop("Datasettet mangler årskolonnen `Aar`.", call. = FALSE)
  }
  
  if (!variable %in% names(data)) {
    stop("Fant ikke variabelen i datasettet: ", variable, call. = FALSE)
  }
  
  if (is.null(metadata)) {
    metadata <-
      if (is_international) {
        get_international_metadata()
      } else {
        get_normacro_metadata()
      }
  }
  
  if (!is.data.frame(metadata)) {
    stop("`metadata` må være et datasett.", call. = FALSE)
  }
  
  if (!"Variabel" %in% names(metadata)) {
    stop("Metadata mangler kolonnen `Variabel`.", call. = FALSE)
  }
  
  display <-
    get_display_name(variable, metadata)
  
  meta <-
    metadata |>
    dplyr::filter(.data$Variabel == variable)
  
  analysis_type <- "nivå"
  
  if (nrow(meta) > 0 &&
      "Analyse_type" %in% names(meta)) {
    analysis_type <- meta$Analyse_type[1]
    
    if (is.na(analysis_type) ||
        analysis_type == "") {
      analysis_type <- "nivå"
    }
  }
  
  cov <-
    coverage(data) |>
    dplyr::filter(.data$Variabel == variable)
  
  latest <-
    latest_observations(data = data) |>
    dplyr::filter(.data$Variabel == variable)
  
  growth <- NULL
  rate_summary <- NULL
  
  if (analysis_type %in% c("nivå", "indeks")) {
    growth <-
      growth_table(variables = variable,
                   data = data,
                   periods = c(1, 5, 10))
    
    if ("Variabel" %in% names(growth)) {
      growth <-
        growth |>
        dplyr::mutate(Display_navn =
                        get_display_name(Variabel, metadata))
      
    }
    
  } else {
    x <-
      data[[variable]]
    
    rate_summary <-
      tibble::tibble(
        Display_navn = display,
        
        Siste_aar =
          max(data$Aar[!is.na(x)]),
        
        Siste_verdi =
          tail(stats::na.omit(x), 1),
        
        Gjennomsnitt =
          mean(x, na.rm = TRUE),
        
        Median =
          stats::median(x, na.rm = TRUE),
        
        Minimum =
          min(x, na.rm = TRUE),
        
        Maksimum =
          max(x, na.rm = TRUE),
        
        Standardavvik =
          stats::sd(x, na.rm = TRUE)
        
      )
    
  }
  
  if ("Variabel" %in% names(growth)) {
    growth <-
      growth |>
      dplyr::mutate(
        Display_navn = vapply(.data$Variabel, get_display_name, character(1), metadata = metadata)
      )
  }
  
  if (is.null(correlation_variables)) {
    numeric_variables <-
      names(data)[vapply(data, is.numeric, logical(1))]
    
    correlation_variables <-
      setdiff(numeric_variables, c("Aar", variable))
  }
  
  if (!is.character(correlation_variables)) {
    stop("`correlation_variables` må være en tegnvektor eller `NULL`.",
         call. = FALSE)
  }
  
  correlation_variables <-
    correlation_variables |>
    unique() |>
    intersect(names(data))
  
  correlations <- NULL
  
  if (length(correlation_variables) > 0L) {
    correlation_variables <-
      correlation_variables[vapply(data[correlation_variables], is.numeric, logical(1))]
    
    correlation_variables <-
      setdiff(correlation_variables, variable)
  }
  
  if (length(correlation_variables) > 0L) {
    correlation_matrix_variables <-
      c(variable, correlation_variables)
    
    correlation_result <-
      correlation_matrix(correlation_matrix_variables, data = data)
    
    if (variable %in% colnames(correlation_result) &&
        variable %in% rownames(correlation_result)) {
      correlations <-
        tibble::tibble(
          Variabel = rownames(correlation_result),
          Korrelasjon = as.numeric(correlation_result[, variable])
        ) |>
        dplyr::filter(.data$Variabel != variable) |>
        dplyr::filter(!is.na(.data$Korrelasjon)) |>
        dplyr::mutate(
          Display_navn = vapply(
            .data$Variabel,
            get_display_name,
            character(1),
            metadata = metadata
          ),
          Absolutt_korrelasjon = abs(.data$Korrelasjon)
        ) |>
        dplyr::arrange(dplyr::desc(.data$Absolutt_korrelasjon)) |>
        dplyr::slice_head(n = top_n_correlations) |>
        dplyr::select(Display_navn, Variabel, Korrelasjon)
    }
  }
  
  cat("\n")
  cat("Variabel\n")
  cat("--------\n")
  cat(display, "\n")
  cat("(", variable, ")\n", sep = "")
  
  if (is_international) {
    cat("Land: ", country, "\n", sep = "")
  }
  
  cat("\n")
  
  if (nrow(meta) > 0L) {
    if ("Beskrivelse" %in% names(meta) &&
        !is.na(meta$Beskrivelse[1]) &&
        meta$Beskrivelse[1] != "") {
      cat("Beskrivelse\n")
      cat("-----------\n")
      cat(meta$Beskrivelse[1], "\n\n")
    }
    
    cat("Metadata\n")
    cat("--------\n")
    
    if ("Kategori" %in% names(meta)) {
      cat("Kategori: ", meta$Kategori[1], "\n", sep = "")
    }
    
    if ("Type" %in% names(meta)) {
      cat("Type:     ", meta$Type[1], "\n", sep = "")
    }
    
    if ("Kilde" %in% names(meta)) {
      cat("Kilde:    ", meta$Kilde[1], "\n", sep = "")
    }
    
    if ("Enhet" %in% names(meta)) {
      cat("Enhet:    ", meta$Enhet[1], "\n", sep = "")
    }
    
    if ("Frekvens" %in% names(meta)) {
      cat("Frekvens: ", meta$Frekvens[1], "\n", sep = "")
    }
    
    cat("\n")
  }
  
  if (nrow(cov) > 0L) {
    cat("Dekning\n")
    cat("-------\n")
    cat(cov$Startaar_data[1], "-", cov$Sluttaar_data[1], "\n", sep = "")
    cat("Observasjoner: ", cov$Antall_observasjoner[1], "\n\n", sep = "")
  }
  
  if (nrow(latest) > 0L) {
    cat("Siste observasjon\n")
    cat("-----------------\n")
    cat("År:    ", latest$Siste_aar[1], "\n", sep = "")
    cat("Verdi: ", latest$Siste_verdi[1], "\n\n", sep = "")
  }
  
  if (analysis_type %in% c("nivå", "indeks")) {
    cat("Vekst\n")
    cat("-----\n")
    
    print(
      growth |>
        
        dplyr::select(
          dplyr::any_of(c("Display_navn", "Variabel")),
          
          Siste_aar,
          
          Siste_verdi,
          
          dplyr::starts_with("Vekst_"),
          
          dplyr::starts_with("CAGR_")
          
        )
      
    )
    
  } else {
    cat("Oppsummering\n")
    cat("------------\n")
    
    print(rate_summary)
    
  }
  
  if (!is.null(correlations) &&
      nrow(correlations) > 0L) {
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
      rate_summary = rate_summary,
      correlations = correlations
    )
  )
}