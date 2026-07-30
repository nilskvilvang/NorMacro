
kostra_indicators_12135 <- function() {
  config <- kostra_table_12135()
  
  dimension_metadata <-
    get_kostra_dimension_metadata(
      url = config$url,
      code = config$concept_code
    )
  
  indicator_definitions <- tibble::tribble(
    ~Code,   ~Variabel,                                           ~Enhet,         ~Analyse_type,
    "41",    "Obligasjonslaan",                                   "1000 kroner",  "level",
    "411",   "Obligasjonslaan_forfall_etter_neste_regnskapsaar",  "1000 kroner",  "level",
    "412",   "Obligasjonslaan_forfall_neste_regnskapsaar",        "1000 kroner",  "level",
    "42",    "Obligasjonslaan_forfall_neste_regnskapsaar_gammel", "1000 kroner",  "level",
    "43",    "Sertifikatlaan",                                    "1000 kroner",  "level",
    "431",   "Sertifikatlaan_ny_definisjon",                      "1000 kroner",  "level",
    "AGD21", "Avdrag_netto",                                      "1000 kroner",  "level",
    "KG32",  "Langsiktig_gjeld_uten_pensjonsforpliktelser",       "1000 kroner",  "level",
    "KG39",  "Renteeksponert_gjeld",                              "1000 kroner",  "level"
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