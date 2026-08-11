
#' Oppsummer en KOSTRA-indikator
#'
#' Lager en statistisk oppsummering av en KOSTRA-indikator for ett år.
#' Dersom `year` ikke oppgis, brukes siste tilgjengelige år.
#'
#' @param variable Navnet på KOSTRA-indikatoren.
#' @param data Et KOSTRA-datasett.
#' @param year Valgfritt år. Hvis `NULL`, brukes siste tilgjengelige år.
#'
#' @return En tibble med blant annet antall enheter, gjennomsnitt, median,
#'   kvartiler, minimum, maksimum og standardavvik.
#'
#' @examples
#' kostra_summary(
#'   "Netto_driftsresultat",
#'   data = normacro_kostra_example
#' )
#'
#' @export

kostra_summary <- function(
    variable,
    data,
    year = NULL
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
      "`kostra_summary()` krever et KOSTRA-datasett med kolonnene: ",
      paste(
        required_columns,
        collapse = ", "
      ),
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
  
  analysis_data <- data |>
    dplyr::select(
      Enhet,
      Enhet_navn,
      Enhetstype,
      Aar,
      Verdi = dplyr::all_of(variable)
    ) |>
    dplyr::filter(
      !is.na(.data$Verdi)
    )
  
  if (nrow(analysis_data) == 0L) {
    stop(
      "Variabelen `",
      variable,
      "` har ingen observasjoner.",
      call. = FALSE
    )
  }
  
  if (is.null(year)) {
    year <- max(
      analysis_data$Aar,
      na.rm = TRUE
    )
  } else {
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
  }
  
  analysis_data <- analysis_data |>
    dplyr::filter(
      .data$Aar == year
    )
  
  if (nrow(analysis_data) == 0L) {
    stop(
      "Fant ingen observasjoner for `",
      variable,
      "` i ",
      year,
      ".",
      call. = FALSE
    )
  }
  
  values <- analysis_data$Verdi
  
  result <- tibble::tibble(
    Variabel = variable,
    Aar = year,
    Antall_enheter = length(values),
    Gjennomsnitt = mean(
      values,
      na.rm = TRUE
    ),
    Median = stats::median(
      values,
      na.rm = TRUE
    ),
    Minimum = min(
      values,
      na.rm = TRUE
    ),
    Q1 = as.numeric(
      stats::quantile(
        values,
        probs = 0.25,
        na.rm = TRUE,
        names = FALSE
      )
    ),
    Q3 = as.numeric(
      stats::quantile(
        values,
        probs = 0.75,
        na.rm = TRUE,
        names = FALSE
      )
    ),
    Maksimum = max(
      values,
      na.rm = TRUE
    ),
    Standardavvik = stats::sd(
      values,
      na.rm = TRUE
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
  ) <- year
  
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
    "kostra_summary",
    class(result)
  )
  
  result
}
