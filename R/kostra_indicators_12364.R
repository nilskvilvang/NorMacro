
kostra_indicators_12364 <- function() {
  
  config <- kostra_table_12364()
  
  dimension_metadata <-
    get_kostra_dimension_metadata(
      url = config$url,
      code = config$concept_code
    )
  
  indicator_definitions <- dplyr::bind_rows(
    
    # ============================================================
    # Resultater og fond
    # ============================================================
    
    tibble::tribble(
      ~Code,  ~Variabel,                               ~Enhet,    ~Analyse_type,
      "KG14", "Akkumulert_regnskapsmessig_resultat",  "1000 kr", "level",
      "KG15", "Akkumulert_resultat_investering",       "1000 kr", "level",
      "AGD74","Netto_avsetning_bundne_fond",           "1000 kr", "flow",
      "56",   "Disposisjonsfond",                      "1000 kr", "level",
      "5900", "Merforbruk_i_balansen",                 "1000 kr", "level",
      "AGD29","Aarets_merforbruk",                     "1000 kr", "flow"
    ),
    
    # ============================================================
    # Drift
    # ============================================================
    
    tibble::tribble(
      ~Code,   ~Variabel,                  ~Enhet,    ~Analyse_type,
      "AGD13", "Brutto_driftsinntekter",  "1000 kr", "flow",
      "AGD9",  "Brutto_driftsutgifter",   "1000 kr", "flow",
      "AGD18", "Brutto_driftsresultat",   "1000 kr", "flow",
      "AGD23", "Netto_driftsresultat",    "1000 kr", "flow",
      "AGD1",  "Netto_driftsutgifter",    "1000 kr", "flow",
      "AG16",  "Lonnsutgifter",           "1000 kr", "flow"
    ),
    
    # ============================================================
    # Investeringer
    # ============================================================
    
    tibble::tribble(
      ~Code,   ~Variabel,                        ~Enhet,    ~Analyse_type,
      "AGI1",  "Brutto_investeringsutgifter",   "1000 kr", "flow",
      "AGI21", "Egenfinansiering_investeringer","1000 kr", "flow",
      "AGI29", "Bruk_av_laan",                  "1000 kr", "flow",
      "970",   "Overforing_fra_drift",          "1000 kr", "flow",
      "AGI7",  "Aarets_udekket_investering",    "1000 kr", "flow"
    ),
    
    # ============================================================
    # Gjeld og finans
    # ============================================================
    
    tibble::tribble(
      ~Code,   ~Variabel,                      ~Enhet,    ~Analyse_type,
      "KG25",  "Langsiktig_gjeld",            "1000 kr", "level",
      "KG32",  "Langsiktig_gjeld_ekskl_pensjon","1000 kr", "level",
      "KG31",  "Netto_laanegjeld",            "1000 kr", "level",
      "KG39",  "Renteeksponert_gjeld",        "1000 kr", "level",
      "KG40",  "Netto_renteeksponering",      "1000 kr", "level",
      "AGD86", "Netto_finansutgifter",        "1000 kr", "flow",
      "AGD97", "Renter_netto",                "1000 kr", "flow"
    ),
    
    # ============================================================
    # Inntekter
    # ============================================================
    
    tibble::tribble(
      ~Code,  ~Variabel,                           ~Enhet,    ~Analyse_type,
      "AG11", "Frie_inntekter",                   "1000 kr", "flow",
      "A800", "Rammetilskudd",                    "1000 kr", "flow",
      "AG12", "Skatt_inkl_naturressursskatt",     "1000 kr", "flow",
      "AG43", "Naturressursskatt",                "1000 kr", "flow"
    ),
    
    # ============================================================
    # Eiendomsskatt
    # ============================================================
    
    tibble::tribble(
      ~Code,  ~Variabel,                                 ~Enhet,    ~Analyse_type,
      "AG10", "Eiendomsskatt",                          "1000 kr", "flow",
      "AG47", "Eiendomsskatt_bolig_og_fritidsboliger",  "1000 kr", "flow",
      "AG46", "Eiendomsskatt_annen_eiendom",            "1000 kr", "flow",
      "A871", "Eiendomsskatt_vannkraft",                "1000 kr", "flow",
      "A872", "Eiendomsskatt_vindkraft",                "1000 kr", "flow",
      "A873", "Eiendomsskatt_petroleumsanlegg",         "1000 kr", "flow",
      "A876", "Eiendomsskatt_kraftnett_og_naering",     "1000 kr", "flow"
    )
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
