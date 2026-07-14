
category_variables <- function(
    category,
    data = NULL
) {
  
  metadata <- get_metadata(data)
  
  result <- metadata |>
    dplyr::filter(.data$Kategori == category) |>
    dplyr::select(
      Variabel,
      Display_navn,
      Type,
      Beskrivelse,
      Enhet,
      Startaar,
      Sluttaar,
      Kilde,
      Omraade
    ) |>
    dplyr::arrange(
      .data$Type,
      .data$Display_navn,
      .data$Variabel
    )
  
  if (nrow(result) == 0) {
    message(
      "Fant ingen variabler i kategorien: ",
      category
    )
  }
  
  result
}
