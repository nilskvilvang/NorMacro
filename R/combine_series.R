
combine_series <- function(
    norway = NULL,
    international = NULL,
    start_year = NULL,
    end_year = NULL
) {
  
  if (
    is.null(norway) &&
    is.null(international)
  ) {
    stop(
      "Velg minst én norsk eller internasjonal serie.",
      call. = FALSE
    )
  }
  
  results <- list()
  
  if (!is.null(norway)) {
    
    if (
      !is.character(norway) ||
      length(norway) == 0 ||
      any(is.na(norway)) ||
      any(norway == "")
    ) {
      stop(
        "Velg minst én gyldig norsk variabel.",
        call. = FALSE
      )
    }
    
    norway <- unique(norway)
    
    norway_data <- get_normacro()
    norway_metadata <- get_normacro_metadata()
    
    missing_variables <- setdiff(
      norway,
      names(norway_data)
    )
    
    if (length(missing_variables) > 0) {
      stop(
        "Fant ikke norske variabler i datasettet: ",
        paste(missing_variables, collapse = ", "),
        call. = FALSE
      )
    }
    
    norway_result <- norway_data |>
      dplyr::select(
        Aar,
        dplyr::all_of(norway)
      ) |>
      tidyr::pivot_longer(
        cols = -Aar,
        names_to = "Variabel",
        values_to = "Verdi"
      ) |>
      dplyr::left_join(
        norway_metadata |>
          dplyr::select(
            Variabel,
            Display_navn,
            Enhet,
            Kilde
          ),
        by = "Variabel"
      ) |>
      dplyr::mutate(
        Serie_id = paste0(
          "NO_",
          .data$Variabel
        ),
        Datasett = "Norge",
        Land = "NO",
        .before = "Variabel"
      )
    
    results[["norway"]] <- norway_result
  }
  
  if (!is.null(international)) {
    
    if (
      !is.list(international) ||
      is.null(names(international)) ||
      any(names(international) == "")
    ) {
      stop(
        paste0(
          "Internasjonale serier må angis som en navngitt liste, ",
          "for eksempel list(SE = c(\"HICP\", \"BNP_vekst\"))."
        ),
        call. = FALSE
      )
    }
    
    international_data <- get_international_macro()
    international_metadata <- get_international_metadata()
    
    available_countries <- unique(
      international_data$Land
    )
    
    requested_countries <- names(international)
    
    missing_countries <- setdiff(
      requested_countries,
      available_countries
    )
    
    if (length(missing_countries) > 0) {
      stop(
        "Fant ikke land i det internasjonale datasettet: ",
        paste(missing_countries, collapse = ", "),
        call. = FALSE
      )
    }
    
    international_results <- list()
    
    for (country in requested_countries) {
      
      variables <- international[[country]]
      
      if (
        !is.character(variables) ||
        length(variables) == 0 ||
        any(is.na(variables)) ||
        any(variables == "")
      ) {
        stop(
          "Velg minst én gyldig internasjonal variabel for landet: ",
          country,
          call. = FALSE
        )
      }
      
      variables <- unique(variables)
      
      missing_variables <- setdiff(
        variables,
        names(international_data)
      )
      
      if (length(missing_variables) > 0) {
        stop(
          "Fant ikke internasjonale variabler for ",
          country,
          ": ",
          paste(missing_variables, collapse = ", "),
          call. = FALSE
        )
      }
      
      country_result <- international_data |>
        dplyr::filter(
          .data$Land == country
        ) |>
        dplyr::select(
          Aar,
          dplyr::all_of(variables)
        ) |>
        tidyr::pivot_longer(
          cols = -Aar,
          names_to = "Variabel",
          values_to = "Verdi"
        ) |>
        dplyr::left_join(
          international_metadata |>
            dplyr::select(
              Variabel,
              Display_navn,
              Enhet,
              Kilde
            ),
          by = "Variabel"
        ) |>
        dplyr::mutate(
          Serie_id = paste0(
            country,
            "_",
            .data$Variabel
          ),
          Datasett = "Internasjonal",
          Land = country,
          .before = "Variabel"
        )
      
      international_results[[country]] <- country_result
    }
    
    results[["international"]] <- dplyr::bind_rows(
      international_results
    )
  }
  
  result <- dplyr::bind_rows(results)
  
  if (!is.null(start_year)) {
    result <- result |>
      dplyr::filter(
        .data$Aar >= start_year
      )
  }
  
  if (!is.null(end_year)) {
    result <- result |>
      dplyr::filter(
        .data$Aar <= end_year
      )
  }
  
  result <- result |>
    dplyr::select(
      Aar,
      Serie_id,
      Datasett,
      Land,
      Variabel,
      Display_navn,
      Verdi,
      Enhet,
      Kilde
    ) |>
    dplyr::arrange(
      .data$Serie_id,
      .data$Aar
    )
  
  new_comparison_series(
    result,
    normalized = FALSE,
    base_year = NULL
  )
}
