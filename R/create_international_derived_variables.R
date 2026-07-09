
create_international_derived_variables <- function(data) {
  
  data |>
    dplyr::group_by(Land) |>
    dplyr::arrange(Aar, .by_group = TRUE) |>
    dplyr::mutate(
      
      Inflasjon =
        growth_rate(HICP, Aar),
      
      Befolkningsvekst =
        growth_rate(Befolkning, Aar),
      
      BNP_lopende_per_innbygger =
        BNP_lopende * 1e6 / Befolkning,
      
      BNP_vekst =
        growth_rate(BNP_faste_priser, Aar),
      
      Industriproduksjon_vekst =
        growth_rate(Industriproduksjon, Aar),
      
      Sysselsettingsandel =
        Sysselsatte / Befolkning * 100,
      
      Arbeidsproduktivitet =
        BNP_faste_priser * 1e6 / Sysselsatte,
      
      Produktivitetsvekst =
        growth_rate(Arbeidsproduktivitet, Aar),
      
      Arbeidsstyrkeandel =
        Arbeidsstyrke / Befolkning * 100,
      
      Boligprisvekst =
        growth_rate(Boligprisindeks, Aar),
      
      Detaljhandel_vekst =
        growth_rate(Detaljhandel, Aar),
      
      Handelsbalanse =
        Eksport - Import,
      
      Eksportandel_BNP =
        Eksport / BNP_faste_priser * 100,
      
      Importandel_BNP =
        Import / BNP_faste_priser * 100,
      
      Handelsbalanse_andel_BNP =
        Handelsbalanse / BNP_faste_priser * 100,
      
      Privat_konsum_vekst = 
        growth_rate(Privat_konsum, Aar),
      
      Offentlig_konsum_vekst = 
        growth_rate(Offentlig_konsum, Aar),
      
      Privat_konsum_andel_BNP = 
        Privat_konsum / BNP_faste_priser * 100,
      
      Offentlig_konsum_andel_BNP = 
        Offentlig_konsum / BNP_faste_priser * 100,
      
      Investeringsvekst =
        growth_rate(Investeringer, Aar),
      
      Investeringer_andel_BNP =
        Investeringer / BNP_faste_priser * 100
      
    ) |>
    dplyr::ungroup()
  
}

