
summary.comparison_series <- function(object, ...) {
  
  object |>
    dplyr::group_by(
      .data$Serie_id,
      .data$Datasett,
      .data$Land,
      .data$Variabel,
      .data$Display_navn,
      .data$Enhet,
      .data$Kilde
    ) |>
    dplyr::summarise(
      Startaar = if (all(is.na(.data$Verdi))) {
        NA_integer_
      } else {
        min(.data$Aar[!is.na(.data$Verdi)])
      },
      Sluttaar = if (all(is.na(.data$Verdi))) {
        NA_integer_
      } else {
        max(.data$Aar[!is.na(.data$Verdi)])
      },
      Antall_observasjoner = sum(!is.na(.data$Verdi)),
      Antall_mangler = sum(is.na(.data$Verdi)),
      Gjennomsnitt = if (all(is.na(.data$Verdi))) {
        NA_real_
      } else {
        mean(.data$Verdi, na.rm = TRUE)
      },
      Minimum = if (all(is.na(.data$Verdi))) {
        NA_real_
      } else {
        min(.data$Verdi, na.rm = TRUE)
      },
      Maksimum = if (all(is.na(.data$Verdi))) {
        NA_real_
      } else {
        max(.data$Verdi, na.rm = TRUE)
      },
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$Serie_id)
}