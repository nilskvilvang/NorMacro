
missing_data <- function(data = NULL, category = NULL) {
  if (is.null(data)) {
    data <- suppressMessages(get_normacro())
  }
  
  metadata <- get_metadata()
  
  result <- data |>
    tidyr::pivot_longer(cols = -Aar,
                        names_to = "Variabel",
                        values_to = "Verdi") |>
    dplyr::group_by(Variabel) |>
    dplyr::summarise(
      Antall_observasjoner = sum(!is.na(Verdi)),
      Antall_mangler = sum(is.na(Verdi)),
      Andel_mangler = Antall_mangler / dplyr::n() * 100,
      Forste_aar_med_data = ifelse(any(!is.na(Verdi)), min(Aar[!is.na(Verdi)]), NA_integer_),
      Siste_aar_med_data = ifelse(any(!is.na(Verdi)), max(Aar[!is.na(Verdi)]), NA_integer_),
      .groups = "drop"
    ) |>
    dplyr::left_join(metadata |>
                       dplyr::select(Variabel, Kategori, Type, Beskrivelse, Enhet, Kilde),
                     by = "Variabel") |>
    dplyr::select(
      Variabel,
      Kategori,
      Type,
      Beskrivelse,
      Enhet,
      Kilde,
      Antall_observasjoner,
      Antall_mangler,
      Andel_mangler,
      Forste_aar_med_data,
      Siste_aar_med_data
    ) |>
    dplyr::arrange(dplyr::desc(Andel_mangler), Kategori, Variabel)
  
  if (!is.null(category)) {
    result <- result |>
      dplyr::filter(Kategori == category)
  }
  
  result
}
