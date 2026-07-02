
validate_metadata <- function(metadata = NULL){
  
  if(is.null(metadata)){
    metadata <- get_metadata()
  }
  
  expected_cols <- c(
    "Variabel",
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
    "Kommentar"
  )
  
  errors <- character()
  
  missing_cols <- setdiff(expected_cols, names(metadata))
  extra_cols <- setdiff(names(metadata), expected_cols)
  
  if(length(missing_cols) > 0){
    errors <- c(
      errors,
      paste0("Manglende kolonner: ", paste(missing_cols, collapse = ", "))
    )
  }
  
  if(length(extra_cols) > 0){
    errors <- c(
      errors,
      paste0("Uventede kolonner: ", paste(extra_cols, collapse = ", "))
    )
  }
  
  if(!identical(names(metadata), expected_cols)){
    errors <- c(
      errors,
      "Kolonnene står ikke i forventet rekkefølge."
    )
  }
  
  if("Variabel" %in% names(metadata)){
    duplicated_vars <- metadata$Variabel[duplicated(metadata$Variabel)]
    
    if(length(duplicated_vars) > 0){
      errors <- c(
        errors,
        paste0(
          "Dupliserte variabelnavn: ",
          paste(unique(duplicated_vars), collapse = ", ")
        )
      )
    }
    
    if(any(is.na(metadata$Variabel) | metadata$Variabel == "")){
      errors <- c(errors, "Én eller flere rader mangler variabelnavn.")
    }
  }
  
  if("Type" %in% names(metadata)){
    invalid_type <- setdiff(
      unique(metadata$Type),
      c("Original", "Beregnet")
    )
    
    invalid_type <- invalid_type[!is.na(invalid_type)]
    
    if(length(invalid_type) > 0){
      errors <- c(
        errors,
        paste0("Ugyldige verdier i Type: ", paste(invalid_type, collapse = ", "))
      )
    }
  }
  
  if("Kategori" %in% names(metadata)){
    
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
      "Utenriks\u00f8konomi"
    )
    
    valid_categories <- enc2utf8(valid_categories)
    metadata$Kategori <- enc2utf8(metadata$Kategori)
    
    invalid_categories <- setdiff(
      unique(metadata$Kategori),
      valid_categories
    )
    
    invalid_categories <- invalid_categories[!is.na(invalid_categories)]
    
    if(length(invalid_categories) > 0){
      errors <- c(
        errors,
        paste0(
          "Ugyldige kategorier: ",
          paste(invalid_categories, collapse = ", ")
        )
      )
    }
  }
  
  required_text_cols <- c(
    "Beskrivelse",
    "Kilde",
    "Tabell",
    "Enhet",
    "Frekvens",
    "Funksjon",
    "Kommentar"
  )
  
  for(col in intersect(required_text_cols, names(metadata))){
    missing_rows <- which(is.na(metadata[[col]]) | metadata[[col]] == "")
    
    if(length(missing_rows) > 0){
      errors <- c(
        errors,
        paste0(
          "Manglende verdier i ",
          col,
          " på rad: ",
          paste(missing_rows, collapse = ", ")
        )
      )
    }
  }
  
  if(all(c("Startaar", "Sluttaar") %in% names(metadata))){
    bad_years <- which(
      !is.na(metadata$Sluttaar) &
        !is.na(metadata$Startaar) &
        metadata$Startaar > metadata$Sluttaar
    )
    
    if(length(bad_years) > 0){
      errors <- c(
        errors,
        paste0(
          "Startaar er større enn Sluttaar på rad: ",
          paste(bad_years, collapse = ", ")
        )
      )
    }
  }
  
  if(length(errors) > 0){
    message("✗ Metadata-validering feilet:\n")
    for(error in errors){
      message("- ", error)
    }
    
    return(invisible(FALSE))
  }
  
  message("✓ Metadata bestod validering.")
  invisible(TRUE)
}
