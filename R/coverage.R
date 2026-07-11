
coverage <- function(data = NULL){
  
  if(is.null(data)){
    data <- get_normacro()
  }
  
  metadata <- get_metadata(data)
  
  cov <- data |>
    tidyr::pivot_longer(
      cols = -dplyr::any_of(c("Aar", "Land")),
      names_to = "Variabel",
      values_to = "Verdi"
    ) |>
    dplyr::group_by(Variabel) |>
    dplyr::summarise(
      Startaar_data = min(Aar[!is.na(Verdi)], na.rm = TRUE),
      Sluttaar_data = max(Aar[!is.na(Verdi)], na.rm = TRUE),
      Antall_observasjoner = sum(!is.na(Verdi)),
      Antall_mangler = sum(is.na(Verdi)),
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
    dplyr::arrange(Kategori, Variabel)
  
  cov
}
