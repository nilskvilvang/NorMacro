
#' Sammenlign KOSTRA-enheter
#'
#' Sammenligner valgte KOSTRA-enheter for én indikator. Funksjonen kan
#' brukes både til sammenligning i ett år og til å beregne utviklingen
#' siden et angitt startår.
#'
#' @param variable Navnet på KOSTRA-indikatoren.
#' @param data Et KOSTRA-datasett.
#' @param units Valgfri tegnvektor med enhetskoder som skal inkluderes.
#' @param year Valgfritt sluttår. Hvis `NULL`, brukes siste tilgjengelige år.
#' @param start_year Valgfritt startår for beregning av endring over tid.
#' @param descending Logisk. Hvis `TRUE`, rangeres høyeste sluttverdi først.
#'
#' @return En tibble med sammenligning av de valgte KOSTRA-enhetene.
#'
#' @examples
#' compare_kostra_units(
#'   "Netto_driftsresultat",
#'   data = normacro_kostra_example,
#'   units = c("0301", "4601", "5001"),
#'   start_year = 2020
#' )
#'
#' @export

compare_kostra_units <- function(
    variable,
    data,
    units = NULL,
    year = NULL,
    start_year = NULL,
    descending = TRUE
) {
  
  if (!is.data.frame(data)) {
    stop(
      "`data` m\u00e5 v\u00e6re et datasett.",
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
      "`compare_kostra_units()` krever et KOSTRA-datasett med kolonnene: ",
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
      "`variable` m\u00e5 v\u00e6re navnet p\u00e5 \u00e9n gyldig variabel.",
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
      "` m\u00e5 v\u00e6re numerisk.",
      call. = FALSE
    )
  }
  
  if (
    !is.logical(descending) ||
    length(descending) != 1L ||
    is.na(descending)
  ) {
    stop(
      "`descending` m\u00e5 v\u00e6re `TRUE` eller `FALSE`.",
      call. = FALSE
    )
  }
  
  available_units <- data$Enhet |>
    unique() |>
    stats::na.omit() |>
    as.character()
  
  if (is.null(units)) {
    units <- available_units
  } else {
    if (
      !is.character(units) ||
      length(units) == 0L ||
      anyNA(units) ||
      any(units == "")
    ) {
      stop(
        "`units` m\u00e5 v\u00e6re en tegnvektor med gyldige KOSTRA-enheter.",
        call. = FALSE
      )
    }
    
    units <- unique(
      units
    )
    
    missing_units <- setdiff(
      units,
      available_units
    )
    
    if (length(missing_units) > 0L) {
      stop(
        "Fant ikke KOSTRA-enheter i datasettet: ",
        paste(
          missing_units,
          collapse = ", "
        ),
        call. = FALSE
      )
    }
  }
  
  analysis_data <- data |>
    dplyr::filter(
      .data$Enhet %in% units
    )
  
  ranking <- rank_kostra(
    variable = variable,
    data = analysis_data,
    year = year,
    descending = descending
  )
  
  selected_year <- attr(
    ranking,
    "year"
  )
  
  result <- ranking |>
    dplyr::select(
      Rang,
      Enhet,
      Enhet_navn,
      Enhetstype,
      Aar,
      Verdi
    ) |>
    dplyr::rename(
      Aar = Aar,
      Verdi = Verdi
    )
  
  # ------------------------------------------------------------
  # Endring fra startår
  # ------------------------------------------------------------
  
  if (!is.null(start_year)) {
    
    if (
      !is.numeric(start_year) ||
      length(start_year) != 1L ||
      is.na(start_year) ||
      !is.finite(start_year)
    ) {
      stop(
        "`start_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
        call. = FALSE
      )
    }
    
    if (start_year >= selected_year) {
      stop(
        "`start_year` m\u00e5 v\u00e6re mindre enn valgt `year`.",
        call. = FALSE
      )
    }
    
    change <- kostra_change(
      variable = variable,
      data = analysis_data,
      start_year = start_year,
      end_year = selected_year,
      descending = descending
    ) |>
      dplyr::select(
        Enhet,
        Startaar,
        Sluttaar,
        Startverdi,
        Sluttverdi,
        Endring,
        dplyr::any_of(
          c(
            "Endring_prosent",
            "Endring_prosentpoeng"
          )
        )
      )
    
    result <- result |>
      dplyr::left_join(
        change,
        by = "Enhet"
      )
  }
  
  # ------------------------------------------------------------
  # Metadata
  # ------------------------------------------------------------
  
  metadata <- get_metadata(
    data
  )
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
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
  
  analysis_type <- if (
    nrow(meta) > 0L &&
    "Analyse_type" %in% names(meta)
  ) {
    meta$Analyse_type[[1]]
  } else {
    NA_character_
  }
  
  # ------------------------------------------------------------
  # Sortering
  # ------------------------------------------------------------
  
  result <- result |>
    dplyr::arrange(
      .data$Rang,
      .data$Enhet
    )
  
  # ------------------------------------------------------------
  # Attributter
  # ------------------------------------------------------------
  
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
    "unit"
  ) <- measure_unit
  
  attr(
    result,
    "analysis_type"
  ) <- analysis_type
  
  attr(
    result,
    "year"
  ) <- selected_year
  
  attr(
    result,
    "start_year"
  ) <- start_year
  
  attr(
    result,
    "descending"
  ) <- descending
  
  attr(
    result,
    "kostra_table"
  ) <- attr(
    data,
    "kostra_table"
  )
  
  attr(
    result,
    "kostra_title"
  ) <- attr(
    data,
    "kostra_title"
  )
  
  class(result) <- c(
    "kostra_unit_comparison",
    class(result)
  )
  
  result
}
