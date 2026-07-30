
kostra_indicators_13553 <- function() {
  config <- kostra_table_13553()
  
  dimension_metadata <-
    get_kostra_dimension_metadata(
      url = config$url,
      code = config$concept_code
    )
  
  indicator_definitions <- tibble::tribble(
    ~Code,    ~Variabel,                                       ~Enhet,          ~Analyse_type,
    "AGD62",  "Andre_driftsinntekter",                         "1000 kroner",   "level",
    "AG45",   "Andre_statlige_tilskudd_drift",                 "1000 kroner",   "level",
    "AGD63",  "Brutto_kraftinntekter",                         "1000 kroner",   "level",
    "AG10",   "Eiendomsskatt_totalt",                          "1000 kroner",   "level",
    "AG47",   "Eiendomsskatt_bolig_fritidsbolig",              "1000 kroner",   "level",
    "AG46",   "Eiendomsskatt_annen_eiendom",                   "1000 kroner",   "level",
    "AD729",  "Mva_kompensasjon_driftsregnskap",               "1000 kroner",   "level",
    "A800",   "Rammetilskudd",                                 "1000 kroner",   "level",
    "AGD16a", "Salgs_og_leieinntekter_uten_konsesjonskraft",   "1000 kroner",   "level",
    "AG12",   "Skatt_inntekt_og_formue",                       "1000 kroner",   "level",
    "AG44",   "Naturressursskatt",                             "1000 kroner",   "level"
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