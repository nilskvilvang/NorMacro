search_variables <- function(pattern, ignore_case = TRUE){
  
  metadata <- get_metadata()
  
  metadata |>
    dplyr::filter(
      grepl(pattern, Variabel, ignore.case = ignore_case) |
        grepl(pattern, Beskrivelse, ignore.case = ignore_case) |
        grepl(pattern, Kommentar, ignore.case = ignore_case)
    ) |>
    dplyr::select(
      Variabel,
      Beskrivelse,
      Enhet,
      Frekvens,
      Startaar,
      Sluttaar,
      Kilde
    )
}