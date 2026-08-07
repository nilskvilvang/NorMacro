
kostra_change <- function(
    variable,
    data,
    start_year,
    end_year,
    descending = TRUE,
    top_n = NULL
) {
  
  if (!is.data.frame(data)) {
    stop(
      "`data` må være et datasett.",
      call. = FALSE
    )
  }
  
  required_columns <- c(
    "Enhet",
    "Enhet_navn",
    "Enhetstype",
    "Aar"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0L) {
    stop(
      "`kostra_change()` krever et KOSTRA-datasett med kolonnene: ",
      paste(required_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
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
  
  if (!variable %in% names(data)) {
    stop(
      "Fant ikke variabelen i datasettet: ",
      variable,
      call. = FALSE
    )
  }
  
  if (!is.numeric(data[[variable]])) {
    stop(
      "Variabelen `",
      variable,
      "` må være numerisk.",
      call. = FALSE
    )
  }
  
  validate_year <- function(
    value,
    argument
  ) {
    if (
      !is.numeric(value) ||
      length(value) != 1L ||
      is.na(value) ||
      !is.finite(value)
    ) {
      stop(
        "`",
        argument,
        "` må være ett gyldig år.",
        call. = FALSE
      )
    }
  }
  
  validate_year(
    start_year,
    "start_year"
  )
  
  validate_year(
    end_year,
    "end_year"
  )
  
  if (start_year >= end_year) {
    stop(
      "`start_year` må være mindre enn `end_year`.",
      call. = FALSE
    )
  }
  
  if (
    !is.logical(descending) ||
    length(descending) != 1L ||
    is.na(descending)
  ) {
    stop(
      "`descending` må være `TRUE` eller `FALSE`.",
      call. = FALSE
    )
  }
  
  if (!is.null(top_n)) {
    if (
      !is.numeric(top_n) ||
      length(top_n) != 1L ||
      is.na(top_n) ||
      !is.finite(top_n) ||
      top_n < 1
    ) {
      stop(
        "`top_n` må være et positivt heltall eller `NULL`.",
        call. = FALSE
      )
    }
    
    top_n <- as.integer(
      top_n
    )
  }
  
  metadata <- get_metadata(
    data
  )
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
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
  
  display_name <- if (
    nrow(meta) > 0L &&
    "Display_navn" %in% names(meta)
  ) {
    meta$Display_navn[[1]]
  } else {
    stringr::str_to_sentence(
      gsub(
        "_",
        " ",
        variable
      )
    )
  }
  
  measure_unit <- if (
    nrow(meta) > 0L &&
    "Enhet" %in% names(meta)
  ) {
    meta$Enhet[[1]]
  } else {
    NA_character_
  }
  
  analysis_data <- data |>
    dplyr::select(
      Enhet,
      Enhet_navn,
      Enhetstype,
      Aar,
      Verdi = dplyr::all_of(variable)
    )
  
  units <- analysis_data |>
    dplyr::distinct(
      .data$Enhet,
      .data$Enhet_navn,
      .data$Enhetstype
    )
  
  start_values <- analysis_data |>
    dplyr::filter(
      .data$Aar == start_year
    ) |>
    dplyr::select(
      Enhet,
      Startverdi = Verdi
    )
  
  end_values <- analysis_data |>
    dplyr::filter(
      .data$Aar == end_year
    ) |>
    dplyr::select(
      Enhet,
      Sluttverdi = Verdi
    )
  
  result <- units |>
    dplyr::left_join(
      start_values,
      by = "Enhet"
    ) |>
    dplyr::left_join(
      end_values,
      by = "Enhet"
    ) |>
    dplyr::mutate(
      Startaar = start_year,
      Sluttaar = end_year,
      Endring = .data$Sluttverdi - .data$Startverdi
    )
  
  if (analysis_type == "rate") {
    result <- result |>
      dplyr::mutate(
        Endring_prosentpoeng = .data$Endring
      )
  } else {
    result <- result |>
      dplyr::mutate(
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
  }
  
  # Enheter uten komplett periode beholdes foreløpig,
  # men får NA på endringen.
  
  if (descending) {
    result <- result |>
      dplyr::arrange(
        dplyr::desc(.data$Endring),
        .data$Enhet
      )
  } else {
    result <- result |>
      dplyr::arrange(
        .data$Endring,
        .data$Enhet
      )
  }
  
  result <- result |>
    dplyr::mutate(
      Rang = dplyr::if_else(
        is.na(.data$Endring),
        NA_integer_,
        dplyr::row_number()
      ),
      .before = 1
    )
  
  if (!is.null(top_n)) {
    result <- result |>
      dplyr::filter(
        !is.na(.data$Rang)
      ) |>
      dplyr::slice_head(
        n = top_n
      )
  }
  
  result <- result |>
    dplyr::relocate(
      Rang,
      Enhet,
      Enhet_navn,
      Enhetstype,
      Startaar,
      Sluttaar,
      Startverdi,
      Sluttverdi,
      Endring
    )
  
  attr(
    result,
    "variable"
  ) <- variable
  
  attr(
    result,
    "display_name"
  ) <- display_name
  
  attr(
    result,
    "analysis_type"
  ) <- analysis_type
  
  attr(
    result,
    "unit"
  ) <- measure_unit
  
  attr(
    result,
    "start_year"
  ) <- start_year
  
  attr(
    result,
    "end_year"
  ) <- end_year
  
  attr(
    result,
    "descending"
  ) <- descending
  
  class(result) <- c(
    "kostra_change",
    class(result)
  )
  
  result
}
