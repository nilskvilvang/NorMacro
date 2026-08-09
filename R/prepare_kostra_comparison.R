
prepare_kostra_comparison <- function(
    unit,
    start_year,
    end_year,
    variable,
    comparison = c(
      "kostra_group",
      "county",
      "custom"
    ),
    comparison_units = NULL,
    comparison_name = NULL,
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
      "`unit` m\u00e5 v\u00e6re \u00e9n gyldig KOSTRA-enhet.",
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
  
  if (
    length(start_year) != 1L ||
    length(end_year) != 1L ||
    is.na(start_year) ||
    is.na(end_year)
  ) {
    stop(
      "`start_year` og `end_year` m\u00e5 angi ett \u00e5r hver.",
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
  
  years <- seq.int(
    start_year,
    end_year
  )
  
  # ------------------------------------------------------------
  # Custom comparison
  # ------------------------------------------------------------
  
  if (comparison == "custom") {
    
    if (
      is.null(comparison_units) ||
      !is.character(comparison_units) ||
      length(comparison_units) == 0L ||
      anyNA(comparison_units) ||
      any(comparison_units == "")
    ) {
      stop(
        paste0(
          "`comparison_units` m\u00e5 v\u00e6re en ikke-tom ",
          "karaktervektor med gyldige KOSTRA-enheter ",
          "n\u00e5r `comparison = \"custom\"`."
        ),
        call. = FALSE
      )
    }
    
    comparison_units <- sort(
      unique(
        comparison_units
      )
    )
    
    if (!unit %in% comparison_units) {
      stop(
        paste0(
          "`unit` m\u00e5 inng\u00e5 i `comparison_units` ",
          "n\u00e5r `comparison = \"custom\"`."
        ),
        call. = FALSE
      )
    }
    
    if (
      !is.null(comparison_name) &&
      (
        !is.character(comparison_name) ||
        length(comparison_name) != 1L ||
        is.na(comparison_name) ||
        comparison_name == ""
      )
    ) {
      stop(
        "`comparison_name` m\u00e5 v\u00e6re \u00e9n gyldig tekstverdi eller `NULL`.",
        call. = FALSE
      )
    }
    
    if (is.null(comparison_name)) {
      comparison_name <- "Egendefinert gruppe"
    }
  }
  
  # ------------------------------------------------------------
  # Build comparison data
  # ------------------------------------------------------------
  
  data <- switch(
    comparison,
    
    kostra_group = get_kostra_peer_group_data(
      unit = unit,
      years = years,
      variable = variable,
      table = table
    ),
    
    county = get_kostra_county_peer_group_data(
      unit = unit,
      years = years,
      variable = variable,
      table = table
    ),
    
    custom = get_kostra_analysis_data(
      table = table,
      regions = comparison_units,
      years = years,
      variables = variable
    )
  )
  
  # ------------------------------------------------------------
  # Selected unit
  # ------------------------------------------------------------
  
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
  
  # ------------------------------------------------------------
  # Comparison metadata
  # ------------------------------------------------------------
  
  if (comparison == "kostra_group") {
    
    group_code <- attr(
      data,
      "kostra_group"
    )
    
    group_name <- attr(
      data,
      "kostra_group_name"
    )
    
  } else if (comparison == "county") {
    
    group_code <- attr(
      data,
      "kostra_county"
    )
    
    group_name <- attr(
      data,
      "kostra_county_name"
    )
    
  } else {
    
    group_code <- NULL
    group_name <- comparison_name
  }
  
  # ------------------------------------------------------------
  # Result
  # ------------------------------------------------------------
  
  list(
    data = data,
    unit = unit,
    unit_name = unit_name,
    start_year = start_year,
    end_year = end_year,
    years = years,
    variable = variable,
    comparison = comparison,
    group_code = group_code,
    group_name = group_name,
    comparison_units = if (
      comparison == "custom"
    ) {
      comparison_units
    } else {
      NULL
    },
    comparison_name = if (
      comparison == "custom"
    ) {
      comparison_name
    } else {
      NULL
    },
    table = as.character(table)
  )
}


