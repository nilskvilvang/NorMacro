
category_variables <- function(category){
  
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(Kategori == category) |>
    dplyr::select(
      Variabel,
      Type,
      Beskrivelse,
      Enhet,
      Startaar,
      Sluttaar,
      Kilde
    ) |>
    dplyr::arrange(Type, Variabel)
  
  if(nrow(result) == 0){
    message("Ingen variabler funnet for kategori: ", category)
    return(invisible(result))
  }
  
  result
}
