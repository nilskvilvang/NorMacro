
international_mapping <- function() {
  tibble::tribble(
    ~Variabel,              ~Internasjonal_variabel,   ~Internasjonal_kilde, ~Internasjonal_kildekode, ~Sammenlignbarhet, ~Fase2_prioritet, ~Internasjonal_kommentar,
    
    "KPI",                 "HICP",                    "Eurostat",           NA_character_,           "Full",             "1",              "Harmonisert konsumprisindeks.",
    "Arbeidsledighet",     "Unemployment_rate",       "Eurostat",           NA_character_,           "Høy",              "1",              "Harmonisert arbeidsledighet.",
    "BNP_vekst",           "Real_GDP_growth",         "Eurostat",           NA_character_,           "Høy",              "1",              "Samlet BNP, ikke Fastlands-BNP.",
    "Offentlig_gjeld_BNP", "Gov_debt_gdp",            "Eurostat",           NA_character_,           "Høy",              "1",              "Bruttogjeld i offentlig forvaltning som andel av BNP.",
    "Boligpriser",         "House_price_index",       "Eurostat",           NA_character_,           "Høy",              "2",              "Boligprisindeks, transformeres til årsvekst ved behov."
  )
}