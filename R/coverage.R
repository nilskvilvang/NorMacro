
coverage <- function(data = NULL) {
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet må inneholde kolonnen `Aar`.",
      call. = FALSE
    )
  }
  
  metadata <- get_metadata(data)
  
  id_columns <- c(
    "Aar",
    "Land",
    "Enhet",
    "Enhet_navn",
    "Enhetstype"
  )
  
  variable_names <- setdiff(
    names(data),
    id_columns
  )
  
  if (length(variable_names) == 0L) {
    stop(
      "Fant ingen variabler å beregne dekning for.",
      call. = FALSE
    )
  }
  
  result <- data |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(variable_names),
      names_to = "Variabel",
      values_to = "Verdi"
    ) |>
    dplyr::group_by(
      .data$Variabel
    ) |>
    dplyr::summarise(
      Startaar_data = if (
        all(is.na(.data$Verdi))
      ) {
        NA_integer_
      } else {
        min(
          .data$Aar[!is.na(.data$Verdi)]
        )
      },
      Sluttaar_data = if (
        all(is.na(.data$Verdi))
      ) {
        NA_integer_
      } else {
        max(
          .data$Aar[!is.na(.data$Verdi)]
        )
      },
      Antall_observasjoner = sum(
        !is.na(.data$Verdi)
      ),
      Antall_mangler = sum(
        is.na(.data$Verdi)
      ),
      .groups = "drop"
    )
  
  if (
    !is.null(metadata) &&
    nrow(metadata) > 0L
  ) {
    
    metadata_columns <- c(
      "Variabel",
      "Display_navn",
      "Kategori",
      "Type",
      "Beskrivelse",
      "Enhet",
      "Analyse_type"
    )
    
    metadata_subset <- metadata |>
      dplyr::select(
        dplyr::any_of(
          metadata_columns
        )
      )
    
    result <- result |>
      dplyr::left_join(
        metadata_subset,
        by = "Variabel"
      )
  }
  
  if ("Kategori" %in% names(result)) {
    result <- result |>
      dplyr::arrange(
        .data$Kategori,
        .data$Variabel
      )
  } else {
    result <- result |>
      dplyr::arrange(
        .data$Variabel
      )
  }
  
  result
}
