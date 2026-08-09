
validate_metadata <- function(
    metadata = NULL,
    verbose = FALSE
) {
  if (is.null(metadata)) {
    metadata <- get_metadata()
  }
  
  expected_cols <- c(
    "Variabel",
    "Display_navn",
    "Type",
    "Kategori",
    "Beskrivelse",
    "Kilde",
    "Kilde_url",
    "Tabell",
    "Enhet",
    "Frekvens",
    "Startaar",
    "Sluttaar",
    "Funksjon",
    "Kommentar",
    "Omraade",
    "Analyse_type"
  )
  
  errors <- character()
  
  missing_cols <- setdiff(
    expected_cols,
    names(metadata)
  )
  
  extra_cols <- setdiff(
    names(metadata),
    expected_cols
  )
  
  if (length(missing_cols) > 0L) {
    errors <- c(
      errors,
      paste0(
        "Manglende kolonner: ",
        paste(missing_cols, collapse = ", ")
      )
    )
  }
  
  if (length(extra_cols) > 0L) {
    errors <- c(
      errors,
      paste0(
        "Uventede kolonner: ",
        paste(extra_cols, collapse = ", ")
      )
    )
  }
  
  if (!identical(names(metadata), expected_cols)) {
    errors <- c(
      errors,
      "Kolonnene st\u00e5r ikke i forventet rekkef\u00f8lge."
    )
  }
  
  if ("Variabel" %in% names(metadata)) {
    missing_variable <- which(
      is.na(metadata$Variabel) |
        metadata$Variabel == ""
    )
    
    if (length(missing_variable) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Manglende variabelnavn p\u00e5 rad: ",
          paste(missing_variable, collapse = ", ")
        )
      )
    }
  }
  
  # Samme variabelnavn kan finnes for flere områder.
  # Kombinasjonen Variabel + Omraade skal derimot være unik.
  if (
    all(
      c(
        "Variabel",
        "Omraade"
      ) %in% names(metadata)
    )
  ) {
    duplicate_keys <- metadata |>
      dplyr::count(
        .data$Variabel,
        .data$Omraade,
        name = "Antall"
      ) |>
      dplyr::filter(.data$Antall > 1L)
    
    if (nrow(duplicate_keys) > 0L) {
      duplicate_text <- paste0(
        duplicate_keys$Variabel,
        " [",
        duplicate_keys$Omraade,
        "]",
        collapse = ", "
      )
      
      errors <- c(
        errors,
        paste0(
          "Dupliserte kombinasjoner av Variabel og Omraade: ",
          duplicate_text
        )
      )
    }
  }
  
  if ("Type" %in% names(metadata)) {
    valid_types <- c(
      "Original",
      "Beregnet"
    )
    
    invalid_type <- setdiff(
      unique(metadata$Type),
      valid_types
    )
    
    invalid_type <- invalid_type[
      !is.na(invalid_type)
    ]
    
    if (length(invalid_type) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Ugyldige verdier i Type: ",
          paste(invalid_type, collapse = ", ")
        )
      )
    }
  }
  
  if ("Kategori" %in% names(metadata)) {
    valid_categories <- c(
      "Arbeidsmarked",
      "Boligmarked",
      "Demografi",
      "Energi og r\u00e5varer",
      "Finansmarkeder",
      "Husholdnings\u00f8konomi",
      "Kreditt og husholdninger",
      "L\u00f8nn og inntekt",
      "Nasjonalregnskap",
      "Offentlige finanser",
      "Priser og inflasjon",
      "Produksjon og aktivitet",
      "Utenriks\u00f8konomi",
      "Konjunkturindikatorer"
    )
    
    valid_categories <- enc2utf8(
      valid_categories
    )
    
    categories <- enc2utf8(
      metadata$Kategori
    )
    
    invalid_categories <- setdiff(
      unique(categories),
      valid_categories
    )
    
    invalid_categories <- invalid_categories[
      !is.na(invalid_categories)
    ]
    
    if (length(invalid_categories) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Ugyldige kategorier: ",
          paste(
            invalid_categories,
            collapse = ", "
          )
        )
      )
    }
  }
  
  if ("Omraade" %in% names(metadata)) {
    valid_areas <- c(
      "Norge",
      "Internasjonal"
    )
    
    invalid_areas <- setdiff(
      unique(metadata$Omraade),
      valid_areas
    )
    
    invalid_areas <- invalid_areas[
      !is.na(invalid_areas)
    ]
    
    if (length(invalid_areas) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Ugyldige verdier i Omraade: ",
          paste(invalid_areas, collapse = ", ")
        )
      )
    }
  }
  
  if ("Analyse_type" %in% names(metadata)) {
    valid_analysis_types <- c(
      "rate",
      "niv\u00e5",
      "indeks"
    )
    
    invalid_analysis_types <- setdiff(
      unique(metadata$Analyse_type),
      valid_analysis_types
    )
    
    invalid_analysis_types <-
      invalid_analysis_types[
        !is.na(invalid_analysis_types) &
          invalid_analysis_types != ""
      ]
    
    if (length(invalid_analysis_types) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Ugyldige verdier i Analyse_type: ",
          paste(
            invalid_analysis_types,
            collapse = ", "
          )
        )
      )
    }
  }
  
  required_text_cols <- c(
    "Display_navn",
    "Beskrivelse",
    "Kilde",
    "Tabell",
    "Enhet",
    "Frekvens",
    "Funksjon",
    "Kommentar",
    "Omraade",
    "Analyse_type"
  )
  
  for (
    col in intersect(
      required_text_cols,
      names(metadata)
    )
  ) {
    missing_rows <- which(
      is.na(metadata[[col]]) |
        metadata[[col]] == ""
    )
    
    if (length(missing_rows) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Manglende verdier i ",
          col,
          " p\u00e5 rad: ",
          paste(missing_rows, collapse = ", ")
        )
      )
    }
  }
  
  if (
    all(
      c(
        "Startaar",
        "Sluttaar"
      ) %in% names(metadata)
    )
  ) {
    bad_years <- which(
      !is.na(metadata$Sluttaar) &
        !is.na(metadata$Startaar) &
        metadata$Startaar > metadata$Sluttaar
    )
    
    if (length(bad_years) > 0L) {
      errors <- c(
        errors,
        paste0(
          "Startaar er st\u00f8rre enn Sluttaar p\u00e5 rad: ",
          paste(bad_years, collapse = ", ")
        )
      )
    }
  }
  
  if (length(errors) > 0L) {
    message(
      "\u2717 Metadata-validering feilet:\n"
    )
    
    for (error in errors) {
      message("- ", error)
    }
    
    return(
      invisible(FALSE)
    )
  }
  
  if (verbose) {
    message(
      "\u2713 Metadata bestod validering."
    )
  }
  
  invisible(TRUE)
}
