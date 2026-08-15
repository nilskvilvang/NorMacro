
kostra_indicators_12137 <- function() {
  config <- kostra_table_12137()
  
  dimension_metadata <-
    get_kostra_dimension_metadata(
      url = config$url,
      code = config$concept_code
    )
  
  indicator_definitions <- tibble::tribble(
    ~Code,   ~Variabel,                                      ~Enhet,              ~Analyse_type,
    "AGD9",  "Brutto_driftsutgifter_per_innbygger",          "kroner per innbygger", "level_per_capita",
    "AGD3",  "Korrigerte_brutto_driftsutgifter_per_innbygger","kroner per innbygger", "level_per_capita",
    "AGD1",  "Netto_driftsutgifter_per_innbygger",           "kroner per innbygger", "level_per_capita",
    "AGD13", "Brutto_driftsinntekter_per_innbygger",         "kroner per innbygger", "level_per_capita",
    "AGD23", "Netto_driftsresultat_per_innbygger",           "kroner per innbygger", "level_per_capita",
    "AG12",  "Skatt_inntekt_formue_per_innbygger",           "kroner per innbygger", "level_per_capita",
    "A800",  "Rammetilskudd_per_innbygger",                  "kroner per innbygger", "level_per_capita",
    "AG10",  "Eiendomsskatt_per_innbygger",                  "kroner per innbygger", "level_per_capita",
    "AG11",  "Frie_inntekter_per_innbygger",                 "kroner per innbygger", "level_per_capita",
    "AGD20", "Netto_kraftinntekter_per_innbygger",           "kroner per innbygger", "level_per_capita",
    "AGI1",  "Brutto_investeringsutgifter_per_innbygger",    "kroner per innbygger", "level_per_capita",
    "KG31",  "Netto_laanegjeld_per_innbygger",               "kroner per innbygger", "level_per_capita",
    "KG32",  "Langsiktig_gjeld_uten_pensjon_per_innbygger",  "kroner per innbygger", "level_per_capita",
    "40",    "Pensjonsforpliktelse_per_innbygger",           "kroner per innbygger", "level_per_capita"
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
