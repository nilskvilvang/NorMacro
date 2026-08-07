
compare_periods <- function(
    variables,
    start_year,
    end_year,
    data = NULL
) {
  
  if (is.null(data)) {
    data <- suppressMessages(
      get_normacro()
    )
  }
  
  if (!"Aar" %in% names(data)) {
    stop(
      "Datasettet må inneholde kolonnen `Aar`.",
      call. = FALSE
    )
  }
  
  missing <- setdiff(
    variables,
    names(data)
  )
  
  if (length(missing) > 0L) {
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  if (
    length(start_year) != 1L ||
    is.na(start_year) ||
    !is.numeric(start_year)
  ) {
    stop(
      "`start_year` må være ett numerisk år.",
      call. = FALSE
    )
  }
  
  if (
    length(end_year) != 1L ||
    is.na(end_year) ||
    !is.numeric(end_year)
  ) {
    stop(
      "`end_year` må være ett numerisk år.",
      call. = FALSE
    )
  }
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  has_country <- "Land" %in% names(data)
  
  has_kostra <- all(
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    ) %in% names(data)
  )
  
  # Identifikasjonskolonner for paneldata
  panel_columns <- if (has_kostra) {
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype"
    )
  } else if (has_country) {
    "Land"
  } else {
    character()
  }
  
  # Gjør datasettet langt
  long_data <- data |>
    dplyr::select(
      dplyr::all_of(panel_columns),
      Aar,
      dplyr::all_of(variables)
    ) |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(variables),
      names_to = "Variabel",
      values_to = "Verdi"
    )
  
  key_columns <- c(
    panel_columns,
    "Variabel"
  )
  
  # Alle kombinasjoner som skal finnes i resultatet
  keys <- long_data |>
    dplyr::distinct(
      dplyr::across(
        dplyr::all_of(key_columns)
      )
    )
  
  # Startverdier
  start_values <- long_data |>
    dplyr::filter(
      .data$Aar == start_year
    ) |>
    dplyr::select(
      dplyr::all_of(key_columns),
      Startverdi = Verdi
    )
  
  # Sluttverdier
  end_values <- long_data |>
    dplyr::filter(
      .data$Aar == end_year
    ) |>
    dplyr::select(
      dplyr::all_of(key_columns),
      Sluttverdi = Verdi
    )
  
  result <- keys |>
    dplyr::left_join(
      start_values,
      by = key_columns
    ) |>
    dplyr::left_join(
      end_values,
      by = key_columns
    ) |>
    dplyr::mutate(
      Startaar = start_year,
      Sluttaar = end_year,
      Endring = .data$Sluttverdi - .data$Startverdi,
      Endring_prosent = dplyr::if_else(
        is.na(.data$Startverdi) |
          .data$Startverdi == 0 |
          is.na(.data$Sluttverdi),
        NA_real_,
        (
          .data$Sluttverdi /
            .data$Startverdi -
            1
        ) * 100
      )
    )
  
  # KOSTRA har ennå ikke variabelmetadata i det generelle
  # metadataregisteret.
  if (has_kostra) {
    return(
      result |>
        dplyr::select(
          Enhet,
          Enhet_navn,
          Enhetstype,
          Variabel,
          Startaar,
          Sluttaar,
          Startverdi,
          Sluttverdi,
          Endring,
          Endring_prosent
        ) |>
        dplyr::arrange(
          .data$Enhetstype,
          .data$Enhet,
          .data$Variabel
        )
    )
  }
  
  metadata <- get_metadata(data)
  
  result <- result |>
    dplyr::left_join(
      metadata |>
        dplyr::select(
          Variabel,
          Kategori,
          Beskrivelse,
          Enhet
        ),
      by = "Variabel"
    )
  
  if (has_country) {
    result <- result |>
      dplyr::select(
        Land,
        Variabel,
        Kategori,
        Beskrivelse,
        Enhet,
        Startaar,
        Sluttaar,
        Startverdi,
        Sluttverdi,
        Endring,
        Endring_prosent
      ) |>
      dplyr::arrange(
        .data$Land,
        .data$Kategori,
        .data$Variabel
      )
  } else {
    result <- result |>
      dplyr::select(
        Variabel,
        Kategori,
        Beskrivelse,
        Enhet,
        Startaar,
        Sluttaar,
        Startverdi,
        Sluttverdi,
        Endring,
        Endring_prosent
      ) |>
      dplyr::arrange(
        .data$Kategori,
        .data$Variabel
      )
  }
  
  result
}