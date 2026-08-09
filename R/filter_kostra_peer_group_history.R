
filter_kostra_peer_group_history <- function(
    data,
    unit,
    start_year = NULL,
    end_year = NULL
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
      "`filter_kostra_peer_group_history()` krever et KOSTRA-datasett.",
      call. = FALSE
    )
  }
  
  if (
    !is.character(unit) ||
    length(unit) != 1L ||
    is.na(unit) ||
    unit == ""
  ) {
    stop(
      "`unit` m\u00e5 v\u00e6re \u00e9n gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  available_years <- data$Aar |>
    stats::na.omit()
  
  if (length(available_years) == 0L) {
    stop(
      "Datasettet inneholder ingen gyldige \u00e5r.",
      call. = FALSE
    )
  }
  
  if (is.null(start_year)) {
    start_year <- min(
      available_years
    )
  }
  
  if (is.null(end_year)) {
    end_year <- max(
      available_years
    )
  }
  
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
  
  if (
    !is.numeric(end_year) ||
    length(end_year) != 1L ||
    is.na(end_year) ||
    !is.finite(end_year)
  ) {
    stop(
      "`end_year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
      call. = FALSE
    )
  }
  
  start_year <- as.integer(
    start_year
  )
  
  end_year <- as.integer(
    end_year
  )
  
  if (start_year > end_year) {
    stop(
      "`start_year` kan ikke v\u00e6re st\u00f8rre enn `end_year`.",
      call. = FALSE
    )
  }
  
  peer_history <- get_kostra_peer_group_history(
    unit = unit,
    start_year = start_year,
    end_year = end_year
  )
  
  result <- data |>
    dplyr::filter(
      .data$Aar >= start_year,
      .data$Aar <= end_year
    ) |>
    dplyr::inner_join(
      peer_history |>
        dplyr::select(
          Enhet,
          Aar,
          KOSTRA_gruppe,
          KOSTRA_gruppe_navn
        ),
      by = c(
        "Enhet",
        "Aar"
      )
    ) |>
    dplyr::arrange(
      .data$Aar,
      .data$Enhet
    )
  
  if (nrow(result) == 0L) {
    stop(
      paste0(
        "Ingen observasjoner i datasettet samsvarer med ",
        "den historiske KOSTRA-gruppen."
      ),
      call. = FALSE
    )
  }
  
  attr(
    result,
    "kostra_group_unit"
  ) <- unit
  
  attr(
    result,
    "kostra_group_definition"
  ) <- "historical"
  
  attr(
    result,
    "kostra_group_start_year"
  ) <- start_year
  
  attr(
    result,
    "kostra_group_end_year"
  ) <- end_year
  
  result
}
