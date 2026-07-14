
coverage <- function(
    data = NULL
) {
  
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  metadata <- get_metadata(data)
  
  result <- data |>
    tidyr::pivot_longer(
      cols = -dplyr::any_of(
        c("Aar", "Land")
      ),
      names_to = "Variabel",
      values_to = "Verdi"
    ) |>
    dplyr::group_by(.data$Variabel) |>
    dplyr::summarise(
      Startaar_data = if (all(is.na(.data$Verdi))) {
        NA_integer_
      } else {
        min(.data$Aar[!is.na(.data$Verdi)])
      },
      Sluttaar_data = if (all(is.na(.data$Verdi))) {
        NA_integer_
      } else {
        max(.data$Aar[!is.na(.data$Verdi)])
      },
      Antall_observasjoner = sum(!is.na(.data$Verdi)),
      Antall_mangler = sum(is.na(.data$Verdi)),
      .groups = "drop"
    ) |>
    dplyr::left_join(
      metadata |>
        dplyr::select(
          Variabel,
          Kategori,
          Type,
          Beskrivelse,
          Enhet
        ),
      by = "Variabel"
    ) |>
    dplyr::arrange(
      .data$Kategori,
      .data$Variabel
    )
  
  result
}
