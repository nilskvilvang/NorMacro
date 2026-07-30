
kostra_indicators_12333 <- function() {
  config <- kostra_table_12333()
  
  dimension_metadata <-
    get_kostra_dimension_metadata(
      url = config$url,
      code = config$concept_code
    )
  
  indicator_definitions <- tibble::tribble(
    ~Code,    ~Variabel,                                      ~Enhet,        ~Analyse_type,
    "AGI23",  "Andre_salgsinntekter_investering",             "1000 kroner", "level",
    "AGI4",   "Fond_investeringsregnskap_netto",              "1000 kroner", "level",
    "AGI29",  "Bruk_av_laan_netto",                           "1000 kroner", "level",
    "AGI26",  "Dekning_av_tidligere_aars_udekket_beloep",     "1000 kroner", "level",
    "AI729",  "Mva_kompensasjon_investeringsregnskap",        "1000 kroner", "level",
    "970",    "Overfoering_fra_drift",                        "1000 kroner", "level",
    "AGI31",  "Refusjons_og_overfoeringsinntekter",           "1000 kroner", "level",
    "AI660",  "Salg_av_driftsmidler",                         "1000 kroner", "level",
    "A670",   "Salg_av_fast_eiendom",                         "1000 kroner", "level",
    "AGI6",   "Salg_og_kjoep_av_aksjer_andeler_netto",        "1000 kroner", "level",
    "AGI28",  "Utlaan_netto_investeringsregnskap",            "1000 kroner", "level",
    "AGI7",   "Aarets_udekket_investeringsregnskap",          "1000 kroner", "level"
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