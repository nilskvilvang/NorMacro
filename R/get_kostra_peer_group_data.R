
get_kostra_peer_group_data <- function(
    unit,
    years,
    table = "12134"
) {
  
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
  
  if (
    !is.numeric(years) ||
    length(years) == 0L ||
    anyNA(years) ||
    any(!is.finite(years))
  ) {
    stop(
      "`years` må være en vektor med gyldige år.",
      call. = FALSE
    )
  }
  
  years <- sort(
    unique(
      as.integer(years)
    )
  )
  
  start_year <- min(years)
  end_year <- max(years)
  
  peer_history <- get_kostra_peer_group_history(
    unit = unit,
    start_year = start_year,
    end_year = end_year
  ) |>
    dplyr::filter(
      .data$Aar %in% years
    )
  
  if (nrow(peer_history) == 0L) {
    stop(
      "Fant ingen historisk KOSTRA-gruppe for valgt kommune og periode.",
      call. = FALSE
    )
  }
  
  peer_units <- peer_history$Enhet |>
    unique() |>
    sort()
  
  data <- switch(
    as.character(table),
    
    "12134" = get_kostra_keyfigures(
      regions = peer_units,
      years = years
    ),
    
    stop(
      "KOSTRA-tabell `",
      table,
      "` støttes ikke av `get_kostra_peer_group_data()`.",
      call. = FALSE
    )
  )
  
  result <- data |>
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
      "Fant ingen KOSTRA-data for valgt kommunegruppe og periode.",
      call. = FALSE
    )
  }
  
  selected_group <- peer_history |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::distinct(
      .data$KOSTRA_gruppe,
      .data$KOSTRA_gruppe_navn
    )
  
  attr(result, "kostra_peer_unit") <- unit
  attr(result, "kostra_group_definition") <- "historical"
  attr(result, "kostra_group_start_year") <- start_year
  attr(result, "kostra_group_end_year") <- end_year
  
  if (nrow(selected_group) == 1L) {
    attr(
      result,
      "kostra_group"
    ) <- selected_group$KOSTRA_gruppe[[1]]
    
    attr(
      result,
      "kostra_group_name"
    ) <- selected_group$KOSTRA_gruppe_navn[[1]]
  }
  
  result
}