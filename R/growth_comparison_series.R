
#' Beregn vekst eller endring i sammenligningsserier
#'
#' Beregner prosentvis vekst eller absolutt endring separat for hver serie i
#' et `comparison_series`-objekt.
#'
#' Resultatet beholder `comparison_series`-klassen og får metadata som
#' beskriver transformasjonen og antall perioder.
#'
#' @param x Et `comparison_series`-objekt.
#' @param periods Antall perioder som skal brukes i vekst- eller
#'   endringsberegningen. Må være et positivt heltall.
#' @param percent Logisk. Hvis `TRUE`, beregnes prosentvis vekst. Hvis
#'   `FALSE`, beregnes absolutt endring.
#' @param ... Videre argumenter til metoden.
#'
#' @return Et `comparison_series`-objekt med transformasjonen
#'   `growth_percent` eller `growth_absolute`.
#'
#' @method growth comparison_series
#' @export

growth.comparison_series <- function(x,
                                     periods = 1,
                                     percent = TRUE,
                                     ...) {
  required_columns <- c("Aar", "Serie_id", "Verdi", "Enhet")
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Objektet mangler n\u00f8dvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  if (!is.numeric(periods) ||
      length(periods) != 1 ||
      is.na(periods) ||
      periods < 1 ||
      periods != floor(periods)) {
    stop("`periods` m\u00e5 v\u00e6re et positivt heltall.", call. = FALSE)
  }
  
  periods <- as.integer(periods)
  
  if (!is.logical(percent) ||
      length(percent) != 1 ||
      is.na(percent)) {
    stop("`percent` m\u00e5 v\u00e6re TRUE eller FALSE.", call. = FALSE)
  }
  
  result <- x |>
    tibble::as_tibble() |>
    dplyr::arrange(.data$Serie_id, .data$Aar) |>
    dplyr::group_by(.data$Serie_id) |>
    dplyr::mutate(
      Previous_value = dplyr::lag(.data$Verdi, n = periods),
      Verdi = if (percent) {
        100 * (.data$Verdi /
                 .data$Previous_value -
                 1)
      } else {
        .data$Verdi -
          .data$Previous_value
      }
    ) |>
    dplyr::ungroup() |>
    dplyr::select(-Previous_value)
  
  if (percent) {
    result <- result |>
      dplyr::mutate(Enhet = if (periods == 1) {
        "Prosentvis vekst"
      } else {
        paste0("Prosentvis vekst over ", periods, " perioder")
      })
    
    transformation <- "growth_percent"
    
  } else {
    result <- result |>
      dplyr::mutate(Enhet = if (periods == 1) {
        paste0("Absolutt endring (", .data$Enhet, ")")
      } else {
        paste0("Absolutt endring over ",
               periods,
               " perioder (",
               .data$Enhet,
               ")")
      })
    
    transformation <- "growth_absolute"
  }
  
  new_comparison_series(
    result,
    base_year = NULL,
    transformation = transformation,
    transformation_periods = periods,
    transformation_base_value = NULL
  )
}
