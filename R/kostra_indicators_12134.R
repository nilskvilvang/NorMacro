
kostra_indicators_12134 <- function() {
  tibble::tribble(
    ~ContentsCode,   ~Variabel,                                     ~Display_navn,                                        ~Enhet,    ~Analyse_type,
    "KOSAGD230000",  "Netto_driftsresultat",                        "Netto driftsresultat",                               "prosent", "rate",
    "KOSAGD290000",  "Merforbruk_driftsregnskap",                   "Årets merforbruk i driftsregnskapet",                "prosent", "rate",
    "KOSKG280000",   "Arbeidskapital_uten_premieavvik",             "Arbeidskapital uten premieavvik",                    "prosent", "rate",
    "KOSKG400000",   "Netto_renteeksponering",                      "Netto renteeksponering",                             "prosent", "rate",
    "KOSKG320000",   "Langsiktig_gjeld_uten_pensjonsforpliktelser", "Langsiktig gjeld uten pensjonsforpliktelser",         "prosent", "rate",
    "KOSAG110000",   "Frie_inntekter_per_innbygger",                "Frie inntekter per innbygger",                       "kr",      "nivå",
    "KOSKG210000",   "Fri_egenkapital_drift",                       "Fri egenkapital drift",                              "prosent", "rate",
    "KOSAGI10000",   "Brutto_investeringsutgifter",                 "Brutto investeringsutgifter",                        "prosent", "rate",
    "KOSAGI210000",  "Egenfinansiering_investeringer",              "Egenfinansiering av investeringene",                 "prosent", "rate"
  )
}
