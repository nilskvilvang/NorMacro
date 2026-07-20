
recession_periods <- function(data = NULL,
                              phases = c("Nedgang"),
                              ...) {
  cycle <- business_cycle(data = data, ...)
  
  selected <- cycle |>
    dplyr::filter(Fase %in% phases) |>
    dplyr::arrange(Aar)
  
  if (nrow(selected) == 0) {
    return(
      tibble::tibble(
        Startaar = integer(),
        Sluttaar = integer(),
        Lengde = integer(),
        Fase = character(),
        Gjennomsnittlig_score = numeric(),
        Laveste_score = numeric()
      )
    )
  }
  
  selected |>
    dplyr::mutate(Gruppe = cumsum(
      dplyr::row_number() == 1 |
        Aar != dplyr::lag(Aar) + 1 |
        Fase != dplyr::lag(Fase)
    )) |>
    dplyr::group_by(Gruppe, Fase) |>
    dplyr::summarise(
      Startaar = min(Aar),
      Sluttaar = max(Aar),
      Lengde = dplyr::n(),
      Gjennomsnittlig_score = mean(Score, na.rm = TRUE),
      Laveste_score = min(Score, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::select(Startaar,
                  Sluttaar,
                  Lengde,
                  Fase,
                  Gjennomsnittlig_score,
                  Laveste_score) |>
    dplyr::arrange(Startaar)
}
