
prepare_kostra_comparison <- function(
    unit,
    start_year,
    end_year,
    comparison = c(
      "kostra_group",
      "county"
    ),
    table = "12134"
) {
  
  comparison <- match.arg(
    comparison
  )
  
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
    length(start_year) != 1L ||
    length(end_year) != 1L ||
    is.na(start_year) ||
    is.na(end_year)
  ) {
    stop(
      "`start_year` og `end_year` må angi ett år hver.",
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
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  years <- seq.int(
    start_year,
    end_year
  )
  
  data <- switch(
    comparison,
    
    kostra_group = get_kostra_peer_group_data(
      unit = unit,
      years = years,
      table = table
    ),
    
    county = get_kostra_county_peer_group_data(
      unit = unit,
      years = years,
      table = table
    )
  )
  
  selected <- data |>
    dplyr::filter(
      .data$Enhet == unit
    ) |>
    dplyr::arrange(
      .data$Aar
    )
  
  if (nrow(selected) == 0L) {
    stop(
      "Fant ikke KOSTRA-data for valgt enhet og periode.",
      call. = FALSE
    )
  }
  
  unit_name <- selected$Enhet_navn[[1]]
  
  if (comparison == "kostra_group") {
    
    group_code <- attr(
      data,
      "kostra_group"
    )
    
    group_name <- attr(
      data,
      "kostra_group_name"
    )
    
  } else {
    
    group_code <- attr(
      data,
      "kostra_county"
    )
    
    group_name <- attr(
      data,
      "kostra_county_name"
    )
  }
  
  list(
    data = data,
    unit = unit,
    unit_name = unit_name,
    start_year = start_year,
    end_year = end_year,
    years = years,
    comparison = comparison,
    group_code = group_code,
    group_name = group_name,
    table = as.character(table)
  )
}
