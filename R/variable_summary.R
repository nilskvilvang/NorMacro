
variable_summary <- function(
    variable,
    data = NULL,
    country = NULL,
    unit = NULL,
    metadata = NULL,
    correlation_variables = NULL,
    top_n_correlations = 5
) {
  
  # ------------------------------------------------------------
  # Valider argumenter
  # ------------------------------------------------------------
  
  if (
    !is.character(variable) ||
    length(variable) != 1L ||
    is.na(variable) ||
    variable == ""
  ) {
    stop(
      "`variable` må være navnet på én gyldig variabel.",
      call. = FALSE
    )
  }
  
  if (!is.null(country)) {
    if (
      !is.character(country) ||
      length(country) != 1L ||
      is.na(country) ||
      country == ""
    ) {
      stop(
        "`country` må være én gyldig landkode.",
        call. = FALSE
      )
    }
  }
  
  if (!is.null(unit)) {
    if (
      !is.character(unit) ||
      length(unit) != 1L ||
      is.na(unit) ||
      unit == ""
    ) {
      stop(
        "`unit` må være én gyldig KOSTRA-enhet.",
        call. = FALSE
      )
    }
  }
  
  if (
    !is.numeric(top_n_correlations) ||
    length(top_n_correlations) != 1L ||
    is.na(top_n_correlations) ||
    top_n_correlations < 1
  ) {
    stop(
      "`top_n_correlations` må være et positivt heltall.",
      call. = FALSE
    )
  }
  
  top_n_correlations <- as.integer(
    top_n_correlations
  )
  
  # ------------------------------------------------------------
  # Hent data
  # ------------------------------------------------------------
  
  if (is.null(data)) {
    if (is.null(country)) {
      data <- suppressMessages(
        get_normacro()
      )
    } else {
      data <- suppressMessages(
        get_international_macro()
      )
    }
  }
  
  if (!is.data.frame(data)) {
    stop(
      "`data` må være et datasett.",
      call. = FALSE
    )
  }
  
  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet mangler årskolonnen `Aar`.",
      call. = FALSE
    )
  }
  
  if (!variable %in% names(data)) {
    stop(
      "Fant ikke variabelen i datasettet: ",
      variable,
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Identifiser datasettstype
  # ------------------------------------------------------------
  
  if (is.null(metadata)) {
    metadata <- get_metadata(data)
  }
  
  has_country_column <- "Land" %in% names(data)
  
  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    ) %in% names(data)
  )
  
  is_international <-
    has_country_column ||
    !is.null(country)
  
  kostra_unit_name <- NULL
  kostra_unit_type <- NULL
  kostra_table <- NULL
  kostra_title <- NULL
  
  # ------------------------------------------------------------
  # Internasjonale data
  # ------------------------------------------------------------
  
  if (has_country_column) {
    
    available_countries <- data$Land |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    if (is.null(country)) {
      if (length(available_countries) > 1L) {
        stop(
          paste0(
            "Datasettet inneholder flere land. ",
            "Angi ett land med argumentet `country`."
          ),
          call. = FALSE
        )
      }
      
      country <- available_countries[[1]]
    }
    
    if (!country %in% available_countries) {
      stop(
        "Fant ikke landet i datasettet: ",
        country,
        call. = FALSE
      )
    }
    
    data <- data |>
      dplyr::filter(
        .data$Land == country
      ) |>
      dplyr::select(
        -dplyr::all_of("Land")
      )
  }
  
  # ------------------------------------------------------------
  # KOSTRA-data
  # ------------------------------------------------------------
  
  if (has_kostra) {
    
    available_units <- data$Enhet |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    if (is.null(unit)) {
      if (length(available_units) > 1L) {
        stop(
          paste0(
            "Datasettet inneholder flere KOSTRA-enheter. ",
            "Angi én enhet med argumentet `unit`."
          ),
          call. = FALSE
        )
      }
      
      unit <- available_units[[1]]
    }
    
    if (!unit %in% available_units) {
      stop(
        "Fant ikke KOSTRA-enheten i datasettet: ",
        unit,
        call. = FALSE
      )
    }
    
    # Viktig: hent metadata mens objektet fortsatt
    # har KOSTRA-strukturen og attributtene.

    selected_unit <- data |>
      dplyr::filter(
        .data$Enhet == unit
      )
    
    kostra_unit_name <- selected_unit$Enhet_navn |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    kostra_unit_type <- selected_unit$Enhetstype |>
      unique() |>
      stats::na.omit() |>
      as.character()
    
    if (length(kostra_unit_name) > 0L) {
      kostra_unit_name <- kostra_unit_name[[1]]
    } else {
      kostra_unit_name <- unit
    }
    
    if (length(kostra_unit_type) > 0L) {
      kostra_unit_type <- kostra_unit_type[[1]]
    } else {
      kostra_unit_type <- NA_character_
    }
    
    kostra_table <- attr(
      data,
      "kostra_table"
    )
    
    kostra_title <- attr(
      data,
      "kostra_title"
    )
    
    data <- selected_unit |>
      dplyr::select(
        -dplyr::any_of(
          c(
            "Enhet",
            "Enhet_navn",
            "Enhetstype"
          )
        )
      )
  }
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  if (is.null(metadata)) {
    metadata <- get_metadata(data)
  }
  
  if (!is.data.frame(metadata)) {
    stop(
      "`metadata` må være et datasett.",
      call. = FALSE
    )
  }
  
  if (!"Variabel" %in% names(metadata)) {
    stop(
      "Metadata mangler kolonnen `Variabel`.",
      call. = FALSE
    )
  }
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  if (nrow(meta) > 0L) {
    display <- get_display_name(
      variable,
      metadata
    )
  } else {
    display <- variable |>
      gsub(
        pattern = "_",
        replacement = " "
      ) |>
      stringr::str_to_sentence()
  }
  
  # ------------------------------------------------------------
  # Analysetype
  # ------------------------------------------------------------
  
  analysis_type <- "nivå"
  
  if (
    nrow(meta) > 0L &&
    "Analyse_type" %in% names(meta)
  ) {
    analysis_type <- meta$Analyse_type[[1]]
    
    if (
      is.na(analysis_type) ||
      analysis_type == ""
    ) {
      analysis_type <- "nivå"
    }
  }
  
  # ------------------------------------------------------------
  # Dekning og siste observasjon
  # ------------------------------------------------------------
  
  cov <- coverage(data) |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  latest <- latest_observations(
    data = data
  ) |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  # ------------------------------------------------------------
  # Vekst eller rateoppsummering
  # ------------------------------------------------------------
  
  growth <- NULL
  rate_summary <- NULL
  
  if (analysis_type %in% c("nivå", "indeks")) {
    
    growth <- growth_table(
      variables = variable,
      data = data,
      periods = c(
        1,
        5,
        10
      )
    )
    
    if ("Variabel" %in% names(growth)) {
      growth <- growth |>
        dplyr::mutate(
          Display_navn = vapply(
            .data$Variabel,
            function(x) {
              if (x %in% metadata$Variabel) {
                get_display_name(
                  x,
                  metadata
                )
              } else {
                stringr::str_to_sentence(
                  gsub(
                    "_",
                    " ",
                    x
                  )
                )
              }
            },
            character(1)
          )
        )
    }
    
  } else {
    
    x <- data[[variable]]
    
    valid <- !is.na(x)
    
    if (any(valid)) {
      rate_summary <- tibble::tibble(
        Display_navn = display,
        Siste_aar = max(
          data$Aar[valid]
        ),
        Siste_verdi = x[
          which(valid)[length(which(valid))]
        ],
        Gjennomsnitt = mean(
          x,
          na.rm = TRUE
        ),
        Median = stats::median(
          x,
          na.rm = TRUE
        ),
        Minimum = min(
          x,
          na.rm = TRUE
        ),
        Maksimum = max(
          x,
          na.rm = TRUE
        ),
        Standardavvik = stats::sd(
          x,
          na.rm = TRUE
        )
      )
    }
  }
  
  # ------------------------------------------------------------
  # Korrelasjoner
  # ------------------------------------------------------------
  
  if (is.null(correlation_variables)) {
    
    numeric_variables <- names(data)[
      vapply(
        data,
        is.numeric,
        logical(1)
      )
    ]
    
    correlation_variables <- setdiff(
      numeric_variables,
      c(
        "Aar",
        variable
      )
    )
  }
  
  if (!is.character(correlation_variables)) {
    stop(
      paste0(
        "`correlation_variables` må være ",
        "en tegnvektor eller `NULL`."
      ),
      call. = FALSE
    )
  }
  
  correlation_variables <- correlation_variables |>
    unique() |>
    intersect(
      names(data)
    )
  
  correlations <- NULL
  
  if (length(correlation_variables) > 0L) {
    
    correlation_variables <-
      correlation_variables[
        vapply(
          data[correlation_variables],
          is.numeric,
          logical(1)
        )
      ]
    
    correlation_variables <- setdiff(
      correlation_variables,
      variable
    )
  }
  
  if (length(correlation_variables) > 0L) {
    
    correlation_matrix_variables <- c(
      variable,
      correlation_variables
    )
    
    correlation_result <- correlation_matrix(
      variables = correlation_matrix_variables,
      data = data
    )
    
    if (
      variable %in% colnames(correlation_result) &&
      variable %in% rownames(correlation_result)
    ) {
      
      correlations <- tibble::tibble(
        Variabel = rownames(
          correlation_result
        ),
        Korrelasjon = as.numeric(
          correlation_result[, variable]
        )
      ) |>
        dplyr::filter(
          .data$Variabel != variable
        ) |>
        dplyr::filter(
          !is.na(.data$Korrelasjon)
        ) |>
        dplyr::mutate(
          Display_navn = vapply(
            .data$Variabel,
            function(x) {
              if (x %in% metadata$Variabel) {
                get_display_name(
                  x,
                  metadata
                )
              } else {
                stringr::str_to_sentence(
                  gsub(
                    "_",
                    " ",
                    x
                  )
                )
              }
            },
            character(1)
          ),
          Absolutt_korrelasjon = abs(
            .data$Korrelasjon
          )
        ) |>
        dplyr::arrange(
          dplyr::desc(
            .data$Absolutt_korrelasjon
          )
        ) |>
        dplyr::slice_head(
          n = top_n_correlations
        ) |>
        dplyr::select(
          Display_navn,
          Variabel,
          Korrelasjon
        )
    }
  }
  
  # ------------------------------------------------------------
  # Utskrift
  # ------------------------------------------------------------
  
  cat("\n")
  cat("Variabel\n")
  cat("--------\n")
  cat(display, "\n")
  cat(
    "(",
    variable,
    ")\n",
    sep = ""
  )
  
  if (is_international) {
    cat(
      "Land: ",
      country,
      "\n",
      sep = ""
    )
  }
  
  if (has_kostra) {
    short_unit_name <- sub(
      "\\s+-\\s+.*$",
      "",
      kostra_unit_name
    )
    
    cat(
      "Enhet: ",
      short_unit_name,
      " (",
      unit,
      ")\n",
      sep = ""
    )
  }
  
  cat("\n")
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  if (nrow(meta) > 0L) {
    
    if (
      "Beskrivelse" %in% names(meta) &&
      !is.na(meta$Beskrivelse[1]) &&
      meta$Beskrivelse[1] != ""
    ) {
      cat("Beskrivelse\n")
      cat("-----------\n")
      cat(meta$Beskrivelse[1], "\n\n")
    }
    
    if (has_kostra) {
      
      kostra_table <- attr(data, "kostra_table")
      kostra_title <- attr(data, "kostra_title")
      
      if (
        !is.null(kostra_table) ||
        !is.null(kostra_title)
      ) {
        cat("KOSTRA\n")
        cat("------\n")
        
        if (!is.null(kostra_table)) {
          cat("Tabell: ", kostra_table, "\n", sep = "")
        }
        
        if (!is.null(kostra_title)) {
          cat("Tema:   ", kostra_title, "\n", sep = "")
        }
        
        cat("\n")
      }
      
      cat("Metadata\n")
      cat("--------\n")
      
      if (
        "Enhet" %in% names(meta) &&
        !is.na(meta$Enhet[1])
      ) {
        cat("Måleenhet:   ", meta$Enhet[1], "\n", sep = "")
      }
      
      if (
        "Analyse_type" %in% names(meta) &&
        !is.na(meta$Analyse_type[1])
      ) {
        cat("Analysetype: ", meta$Analyse_type[1], "\n", sep = "")
      }
      
      cat("\n")
      
    } else {
      
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
      
      if ("Analyse_type" %in% names(meta)) {
        cat("Analysetype: ", meta$Analyse_type[1], "\n", sep = "")
      }
      
      cat("\n")
    }
  }
  
  # ------------------------------------------------------------
  # Dekning
  # ------------------------------------------------------------
  
  if (nrow(cov) > 0L) {
    cat("Dekning\n")
    cat("-------\n")
    
    cat(
      cov$Startaar_data[[1]],
      "-",
      cov$Sluttaar_data[[1]],
      "\n",
      sep = ""
    )
    
    cat(
      "Observasjoner: ",
      cov$Antall_observasjoner[[1]],
      "\n\n",
      sep = ""
    )
  }
  
  # ------------------------------------------------------------
  # Siste observasjon
  # ------------------------------------------------------------
  
  if (nrow(latest) > 0L) {
    cat("Siste observasjon\n")
    cat("-----------------\n")
    
    cat(
      "År:    ",
      latest$Siste_aar[[1]],
      "\n",
      sep = ""
    )
    
    cat(
      "Verdi: ",
      latest$Siste_verdi[[1]],
      "\n\n",
      sep = ""
    )
  }
  
  # ------------------------------------------------------------
  # Vekst / oppsummering
  # ------------------------------------------------------------
  
  if (analysis_type %in% c("nivå", "indeks")) {
    
    cat("Vekst\n")
    cat("-----\n")
    
    print(
      growth |>
        dplyr::select(
          dplyr::any_of(
            c(
              "Display_navn",
              "Variabel"
            )
          ),
          Siste_aar,
          Siste_verdi,
          dplyr::starts_with(
            "Vekst_"
          ),
          dplyr::starts_with(
            "CAGR_"
          )
        )
    )
    
  } else if (!is.null(rate_summary)) {
    
    cat("Oppsummering\n")
    cat("------------\n")
    
    print(
      rate_summary
    )
  }
  
  # ------------------------------------------------------------
  # Korrelasjoner
  # ------------------------------------------------------------
  
  if (
    !is.null(correlations) &&
    nrow(correlations) > 0L
  ) {
    cat("\n")
    cat("Sterkeste korrelasjoner\n")
    cat("-----------------------\n")
    
    print(
      correlations
    )
  }
  
  invisible(
    list(
      metadata = meta,
      coverage = cov,
      latest = latest,
      growth = growth,
      rate_summary = rate_summary,
      correlations = correlations,
      country = country,
      kostra_unit = unit,
      kostra_unit_name = kostra_unit_name,
      kostra_table = kostra_table,
      kostra_title = kostra_title
    )
  )
}
