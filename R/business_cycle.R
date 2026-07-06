
business_cycle <- function(
    data = NULL,
    recession_max = -8,
    slowdown_max = -2,
    boom_min = 6,
    ...
){
  
  score <- business_cycle_score(
    data = data,
    ...
  )
  
  score |>
    dplyr::mutate(
      Fase = dplyr::case_when(
        Score <= recession_max ~ "Nedgang",
        Score > recession_max & Score <= slowdown_max ~ "Svak vekst",
        Score >= boom_min ~ "Høykonjunktur",
        TRUE ~ "Ekspansjon"
      )
    ) |>
    dplyr::select(
      Aar,
      Fase,
      Score,
      Antall_indikatorer,
      dplyr::everything()
    )
}
