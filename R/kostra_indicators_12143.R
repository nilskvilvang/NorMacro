
kostra_indicators_12143 <- function() {
  config <- kostra_table_12143()
  
  dimension_metadata <-
    get_kostra_dimension_metadata(
      url = config$url,
      code = config$concept_code
    )
  
  indicator_definitions <- tibble::tribble(
    ~Code,   ~Variabel,               ~Enhet,    ~Analyse_type,
    "AGD23", "Netto_driftsresultat",  "prosent", "rate"
  )
  
  indicator_definitions |>
    dplyr::left_join(
      dimension_metadata,
      by = "Code"
    ) |>
    dplyr::rename(
      KOKartkap0000 = Code
    ) |>
    dplyr::select(
      KOKartkap0000,
      Variabel,
      Display_navn,
      Enhet,
      Analyse_type
    )
}
