
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
        growth_rate(Arbeidsproduktivitet, Aar)
      
    ) |>
    dplyr::ungroup()
  
}

