
benchmark_kostra <- function(
    variable,
    data = NULL,
    unit = NULL,
    year = NULL,
    descending = TRUE,
    comparison = c(
      "data",
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
      "`unit` m\u00e5 angi \u00e9n gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  # ------------------------------------------------------------
  # Bygg sammenligningsunivers når dette ikke kommer fra data
  # ------------------------------------------------------------
  
  comparison_info <- NULL
  
  if (comparison != "data") {
    
    if (is.null(year)) {
      year <- as.integer(
        format(
          Sys.Date(),
          "%Y"
        )
      )
    }
    
    if (
      !is.numeric(year) ||
      length(year) != 1L ||
      is.na(year) ||
      !is.finite(year)
    ) {
      stop(
        "`year` m\u00e5 v\u00e6re ett gyldig \u00e5r.",
        call. = FALSE
      )
    }
    
    year <- as.integer(
      year
    )
    
    comparison_info <- prepare_kostra_comparison(
      unit = unit,
      start_year = year,
      end_year = year,
      variable = variable,
      comparison = comparison,
      comparison_units = comparison_units,
      comparison_name = comparison_name,
      table = table
    )
    
    data <- comparison_info$data
  }
  
  # ------------------------------------------------------------
  # Ordinær data-sammenligning
  # ------------------------------------------------------------
  
  if (is.null(data)) {
    stop(
      "`data` m\u00e5 oppgis n\u00e5r `comparison = \"data\"`.",
      call. = FALSE
    )
  }
  
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
      "`benchmark_kostra()` krever et KOSTRA-datasett.",
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
  
  available_units <- unique(
    data$Enhet
  )
  
  if (!unit %in% available_units) {
    stop(
      "Fant ikke KOSTRA-enheten: ",
      unit,
      call. = FALSE
    )
  }
  
  ranking <- rank_kostra(
    variable = variable,
    data = data,
    year = year,
    descending = descending
  )
  
  selected_year <- attr(
    ranking,
    "year"
  )
  
  summary <- kostra_summary(
    variable = variable,
    data = data,
    year = selected_year
  )
  
  selected <- ranking |>
    dplyr::filter(
      .data$Enhet == unit
    )
  
  if (nrow(selected) == 0L) {
    stop(
      "Enheten mangler observasjon for valgt \u00e5r.",
      call. = FALSE
    )
  }
  
  value <- selected$Verdi[[1]]
  
  n_units <- summary$Antall_enheter[[1]]
  
  result <- tibble::tibble(
    Enhet = selected$Enhet[[1]],
    Enhet_navn = selected$Enhet_navn[[1]],
    Enhetstype = selected$Enhetstype[[1]],
    Aar = selected_year,
    Variabel = variable,
    Verdi = value,
    Rang = selected$Rang[[1]],
    Antall_enheter = n_units,
    Percentil = if (n_units <= 1L) {
      NA_real_
    } else {
      (
        n_units -
          selected$Rang[[1]]
      ) /
        (
          n_units -
            1
        ) *
        100
    },
    Gjennomsnitt = summary$Gjennomsnitt[[1]],
    Median = summary$Median[[1]],
    Avvik_gjennomsnitt = value -
      summary$Gjennomsnitt[[1]],
    Avvik_median = value -
      summary$Median[[1]],
    Q1 = summary$Q1[[1]],
    Q3 = summary$Q3[[1]]
  )
  
  result <- result |>
    dplyr::mutate(
      Kvartil = dplyr::case_when(
        .data$Verdi <= .data$Q1 ~ 1L,
        .data$Verdi <= .data$Median ~ 2L,
        .data$Verdi <= .data$Q3 ~ 3L,
        TRUE ~ 4L
      )
    )
  
  # ------------------------------------------------------------
  # Legg på sammenligningsmetadata i selve resultatet
  # ------------------------------------------------------------
  
  if (!is.null(comparison_info)) {
    
    if (comparison == "kostra_group") {
      
      result <- result |>
        dplyr::mutate(
          KOSTRA_gruppe = comparison_info$group_code,
          KOSTRA_gruppe_navn = comparison_info$group_name,
          .after = Enhetstype
        )
      
    } else if (comparison == "county") {
      
      result <- result |>
        dplyr::mutate(
          Fylke = comparison_info$group_code,
          Fylke_navn = comparison_info$group_name,
          .after = Enhetstype
        )
    }
  }
  
  # ------------------------------------------------------------
  # Variabelmetadata
  # ------------------------------------------------------------
  
  metadata <- get_metadata(
    data
  )
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  if (nrow(meta) > 0L) {
    
    if ("Display_navn" %in% names(meta)) {
      attr(
        result,
        "display_name"
      ) <- meta$Display_navn[[1]]
    }
    
    if ("Enhet" %in% names(meta)) {
      attr(
        result,
        "unit"
      ) <- meta$Enhet[[1]]
    }
    
    if ("Analyse_type" %in% names(meta)) {
      attr(
        result,
        "analysis_type"
      ) <- meta$Analyse_type[[1]]
    }
  }
  
  # ------------------------------------------------------------
  # Analysemetadata
  # ------------------------------------------------------------
  
  attr(
    result,
    "variable"
  ) <- variable
  
  attr(
    result,
    "year"
  ) <- selected_year
  
  attr(
    result,
    "descending"
  ) <- descending
  
  attr(
    result,
    "comparison"
  ) <- comparison
  
  if (!is.null(comparison_info)) {
    
    comparison_group <- switch(
      comparison,
      kostra_group = "KOSTRA-gruppe",
      county = "Fylke",
      custom = "Egendefinert gruppe"
    )
    
    attr(
      result,
      "comparison_group"
    ) <- comparison_group
    
    attr(
      result,
      "comparison_group_code"
    ) <- comparison_info$group_code
    
    attr(
      result,
      "comparison_group_name"
    ) <- comparison_info$group_name
    
    if (comparison == "custom") {
      
      attr(
        result,
        "comparison_units"
      ) <- comparison_info$comparison_units
    }
  }
  
  class(result) <- c(
    "kostra_benchmark",
    class(result)
  )
  
  result
}


