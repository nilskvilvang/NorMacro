
benchmark_kostra <- function(
    variable,
    data = NULL,
    unit = NULL,
    year = NULL,
    descending = TRUE,
    comparison = c(
      "data",
      "kostra_group"
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
      "`unit` må angi én gyldig KOSTRA-enhet.",
      call. = FALSE
    )
  }
  
  if (comparison == "kostra_group") {
    
    return(
      benchmark_kostra_peer_group(
        variable = variable,
        unit = unit,
        year = year,
        descending = descending,
        table = table
      )
    )
  }
  
  if (is.null(data)) {
    stop(
      "`data` må oppgis når `comparison = \"data\"`.",
      call. = FALSE
    )
  }
  
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
      "Enheten mangler observasjon for valgt år.",
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
  
  class(result) <- c(
    "kostra_benchmark",
    class(result)
  )
  
  result
}
