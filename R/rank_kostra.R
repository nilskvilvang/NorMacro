
#' Ranger KOSTRA-enheter
#'
#' Rangerer kommuner eller andre KOSTRA-enheter etter verdien på en valgt
#' indikator i ett år.
#'
#' @param variable Navnet på KOSTRA-indikatoren.
#' @param data Et KOSTRA-datasett.
#' @param year Valgfritt år. Hvis `NULL`, brukes siste tilgjengelige år.
#' @param descending Logisk. Hvis `TRUE`, rangeres høyeste verdi først.
#' @param top_n Valgfritt antall øverste enheter som skal returneres.
#'
#' @return En tibble med rangering, enhetsinformasjon, år og verdi.
#'
#' @examples
#' rank_kostra(
#'   "Netto_driftsresultat",
#'   data = normacro_kostra_example,
#'   year = 2025
#' )
#'
#' @export

rank_kostra <- function(
    variable,
    data,
    year = NULL,
    descending = TRUE,
    top_n = NULL
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
      "`rank_kostra()` krever et KOSTRA-datasett med kolonnene: ",
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
  
  if (!is.null(top_n)) {
    if (
      !is.numeric(top_n) ||
      length(top_n) != 1L ||
      is.na(top_n) ||
      !is.finite(top_n) ||
      top_n < 1
    ) {
      stop(
        "`top_n` m\u00e5 v\u00e6re et positivt heltall eller `NULL`.",
        call. = FALSE
      )
    }
    
    top_n <- as.integer(top_n)
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
  
  result <- analysis_data |>
    dplyr::filter(
      .data$Aar == year
    )
  
  if (nrow(result) == 0L) {
    stop(
      "Fant ingen observasjoner for `",
      variable,
      "` i ",
      year,
      ".",
      call. = FALSE
    )
  }
  
    if (descending) {
    result <- result |>
      dplyr::arrange(
        dplyr::desc(.data$Verdi),
        .data$Enhet
      ) |>
      dplyr::mutate(
        Rang = dplyr::min_rank(
          dplyr::desc(.data$Verdi)
        ),
        .before = 1
      )
  } else {
    result <- result |>
      dplyr::arrange(
        .data$Verdi,
        .data$Enhet
      ) |>
      dplyr::mutate(
        Rang = dplyr::min_rank(
          .data$Verdi
        ),
        .before = 1
      )
  }
  
  if (!is.null(top_n)) {
    result <- result |>
      dplyr::slice_head(
        n = top_n
      )
  }
  
  metadata <- get_metadata(data)
  
  meta <- metadata |>
    dplyr::filter(
      .data$Variabel == variable
    )
  
  attr(result, "variable") <- variable
  attr(result, "year") <- year
  attr(result, "descending") <- descending
  
  if (nrow(meta) > 0L) {
    if ("Display_navn" %in% names(meta)) {
      attr(result, "display_name") <- meta$Display_navn[1]
    }
    
    if ("Enhet" %in% names(meta)) {
      attr(result, "unit") <- meta$Enhet[1]
    }
    
    if ("Analyse_type" %in% names(meta)) {
      attr(result, "analysis_type") <- meta$Analyse_type[1]
    }
  }
  
  class(result) <- c(
    "kostra_ranking",
    class(result)
  )
  
  result
}
