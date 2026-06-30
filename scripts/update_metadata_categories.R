
source("source_all.R")

metadata <- get_metadata()

metadata <- metadata |>
  dplyr::mutate(
    Kategori = dplyr::case_when(
      
      Variabel %in% c(
        "Befolkning",
        "Befolkningsvekst"
      ) ~ "Demografi",
      
      Variabel %in% c(
        "KPI",
        "Inflasjon"
      ) ~ "Priser og inflasjon",
      
      Variabel %in% c(
        "Arbeidsstyrke",
        "Sysselsatte",
        "Menn_arbledige_NAV",
        "Kvinner_arbledige_NAV",
        "Arbledige_NAV",
        "Arbledighetsrate_NAV",
        "Kvinneandel_arbledige_NAV",
        "Arbeidsstyrkeandel",
        "Arbledige_andel_arbeidsstyrke_NAV"
      ) ~ "Arbeidsmarked",
      
      Variabel %in% c(
        "Lonn",
        "Lonnvekst",
        "Reallonnsvekst",
        "Disponibel_inntekt_husholdninger"
      ) ~ "Lønn og inntekt",
      
      Variabel %in% c(
        "Privat_konsum",
        "Privat_konsum_vekst",
        "Privat_konsum_andel_BNP",
        "Husholdningssparing",
        "Husholdningssparing_vekst",
        "Husholdningssparing_andel_disponibel_inntekt"
      ) ~ "Husholdningsøkonomi",
      
      Variabel %in% c(
        "Boligprisindeks",
        "Boligprisvekst",
        "Boliginvesteringer",
        "Boliginvesteringer_vekst",
        "Boliginvesteringer_andel_BNP"
      ) ~ "Boligmarked",
      
      Variabel %in% c(
        "Kreditt_K2",
        "Kredittvekst_K2",
        "Husholdningsgjeldsrate",
        "Husholdningsfordringsrate",
        "Husholdningsnettofordringsrate",
        "Husholdningsgjeldsvekst"
      ) ~ "Kreditt og husholdninger",
      
      Variabel %in% c(
        "Styringsrente",
        "Valutakurs_I44",
        "Valutakurs_I44_vekst",
        "OSEAX",
        "OSEAX_vekst"
      ) ~ "Finansmarkeder",
      
      Variabel %in% c(
        "Offentlig_gjeld",
        "Offentlig_nettofordringer",
        "Offentlig_gjeld_andel_BNP",
        "Offentlig_nettofordringer_andel_BNP",
        "Offentlige_utgifter",
        "Statlige_utgifter",
        "Kommunale_utgifter",
        "Kommunal_utgiftsandel",
        "Statlig_utgiftsandel",
        "Offentlige_investeringer",
        "Offentlige_investeringer_vekst",
        "Offentlige_investeringer_andel_BNP",
        "Offentlig_konsum",
        "Offentlig_konsum_vekst",
        "Offentlig_konsum_andel_BNP"
      ) ~ "Offentlige finanser",
      
      Variabel %in% c(
        "BNP_lopende",
        "BNP_Fastland",
        "BNP_Fastland_vekst",
        "BNP_Fastland_per_innbygger",
        "BNP_Fastland_per_innbygger_vekst",
        "BNP_lopende_per_innbygger",
        "Arbeidsproduktivitet",
        "Produktivitetsvekst"
      ) ~ "Nasjonalregnskap",
      
      Variabel %in% c(
        "Eksport",
        "Import",
        "Eksportvekst",
        "Importvekst",
        "Handelsbalanse",
        "Handelsbalanse_andel_BNP",
        "Eksportandel_BNP",
        "Importandel_BNP"
      ) ~ "Utenriksøkonomi",
      
      Variabel %in% c(
        "Oljepris_USD",
        "Oljeprisvekst",
        "Strompris",
        "Stromprisvekst"
      ) ~ "Energi og råvarer",
      
      TRUE ~ Kategori
    )
  )

readr::write_csv(metadata, "data/metadata.csv")