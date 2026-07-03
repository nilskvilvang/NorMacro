
conjuncture_dashboard <- function(data = NULL){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  indicators <- leading_indicators(data)
  
  indicators |>
    tidyr::pivot_longer(
      cols = -Aar,
      names_to = "Variabel",
      values_to = "Verdi"
    ) |>
    dplyr::filter(!is.na(Verdi)) |>
    dplyr::left_join(
      get_metadata() |>
        dplyr::select(Variabel, Kategori, Beskrivelse, Enhet, Kilde),
      by = "Variabel"
    ) |>
    dplyr::arrange(Variabel, Aar)
}