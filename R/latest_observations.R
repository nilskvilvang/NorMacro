
latest_observations <- function(data = NULL,
                                category = NULL,
                                source = NULL) {
  if (is.null(data)) {
    data <- suppressMessages(get_normacro())
  }
  
  metadata <- get_metadata()
  
  
  result <- data |>
    tidyr::pivot_longer(cols = -Aar,
                        names_to = "Variabel",
                        values_to = "Verdi") |>
    
    dplyr::filter(!is.na(Verdi)) |>
    dplyr::group_by(Variabel) |>
    dplyr::slice_max(Aar, n = 1, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::rename(Siste_aar = Aar, Siste_verdi = Verdi) |>
    dplyr::left_join(metadata |>
                       dplyr::select(Variabel, Kategori, Type, Beskrivelse, Enhet, Kilde),
                     by = "Variabel") |>
    dplyr::select(Variabel,
                  Kategori,
                  Type,
                  Beskrivelse,
                  Enhet,
                  Kilde,
                  Siste_aar,
                  Siste_verdi) |>
    dplyr::arrange(Kategori, Variabel)
  
  if (!is.null(category)) {
    result <- result |>
      dplyr::filter(Kategori == category)
  }
  
  if (!is.null(source)) {
    result <- result |>
      dplyr::filter(Kilde == source)
  }
  
  result
}
