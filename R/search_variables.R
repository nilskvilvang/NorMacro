
search_variables <- function(
    query,
    ignore_case = TRUE
) {
  
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(
      grepl(
        query,
        .data$Variabel,
        ignore.case = ignore_case
      ) |
        grepl(
          query,
          .data$Display_navn,
          ignore.case = ignore_case
        ) |
        grepl(
          query,
          .data$Beskrivelse,
          ignore.case = ignore_case
        ) |
        grepl(
          query,
          .data$Kommentar,
          ignore.case = ignore_case
        ) |
        grepl(
          query,
          .data$Kategori,
          ignore.case = ignore_case
        )
    ) |>
    dplyr::select(
      Variabel,
      Display_navn,
      Kategori,
      Beskrivelse,
      Enhet,
      Frekvens,
      Startaar,
      Sluttaar,
      Kilde,
      Omraade
    ) |>
    dplyr::arrange(
      .data$Display_navn,
      .data$Variabel
    )
  
  if (nrow(result) == 0) {
    message(
      "Fant ingen variabler som matcher søket: ",
      query
    )
  }
  
  result
}