
get_kostra_county_peer_group_data <- function(
    unit,
    years,
    variable,
    table = "12134"
) {
  
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
  
  if (
    !is.numeric(years) ||
    length(years) == 0L ||
    anyNA(years) ||
    any(!is.finite(years))
  ) {
    stop(
      "`years` m\u00e5 v\u00e6re en vektor med gyldige \u00e5r.",
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
  
  years <- sort(
    unique(
      as.integer(years)
    )
  )
  
  start_year <- min(
    years
  )
  
  end_year <- max(
    years
  )
  
  county_history <- get_kostra_county_peer_group_history(
    unit = unit,
    start_year = start_year,
    end_year = end_year
  ) |>
    dplyr::filter(
      .data$Aar %in% years
    )
  
  if (nrow(county_history) == 0L) {
    stop(
      "Fant ingen historisk fylkestilh\u00f8righet for valgt kommune og periode.",
      call. = FALSE
    )
  }
  
  county_units <- county_history$Enhet |>
    unique() |>
    sort()
  
  data <- get_kostra_analysis_data(
    table = table,
    regions = county_units,
    years = years,
    variables = variable
  )
  
  result <- data |>
    dplyr::inner_join(
      county_history |>
        dplyr::select(
          Enhet,
          Aar,
          Fylke,
          Fylke_navn
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
      "Fant ingen KOSTRA-data for valgt fylkesgruppe og periode.",
      call. = FALSE
    )
  }
  
  selected_county <- county_history |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::distinct(
      Fylke,
      Fylke_navn
    )
  
  attr(
    result,
    "kostra_county_unit"
  ) <- unit
  
  attr(
    result,
    "kostra_county_definition"
  ) <- "historical"
  
  attr(
    result,
    "kostra_county_start_year"
  ) <- start_year
  
  attr(
    result,
    "kostra_county_end_year"
  ) <- end_year
  
  if (nrow(selected_county) == 1L) {
    
    attr(
      result,
      "kostra_county"
    ) <- selected_county$Fylke[[1]]
    
    attr(
      result,
      "kostra_county_name"
    ) <- selected_county$Fylke_navn[[1]]
  }
  
  result
}


