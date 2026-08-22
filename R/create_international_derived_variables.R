
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

      BNP_faste_priser_per_innbygger =
        BNP_faste_priser * 1e6 / Befolkning,

      BNP_faste_priser_per_innbygger_vekst =
        growth_rate(BNP_faste_priser_per_innbygger, Aar),

      BNP_vekst =
        growth_rate(BNP_faste_priser, Aar),

      Industriproduksjon_vekst =
        growth_rate(Industriproduksjon, Aar),

      Arbeidsproduktivitet =
        BNP_faste_priser * 1e6 / Sysselsatte,

      Produktivitetsvekst =
        growth_rate(Arbeidsproduktivitet, Aar),

      Boligprisvekst =
        growth_rate(Boligprisindeks, Aar),

      Detaljhandel_vekst =
        growth_rate(Detaljhandel, Aar),

      Handelsbalanse =
        Eksport - Import,

      Handelsbalanse_lopende =
        Eksport_lopende - Import_lopende,

      Eksportandel_BNP =
        Eksport_lopende / BNP_lopende * 100,

      Importandel_BNP =
        Import_lopende / BNP_lopende * 100,

      Handelsbalanse_andel_BNP =
        Handelsbalanse_lopende / BNP_lopende * 100,

      Privat_konsum_vekst =
        growth_rate(Privat_konsum, Aar),

      Offentlig_konsum_vekst =
        growth_rate(Offentlig_konsum, Aar),

      Privat_konsum_andel_BNP =
        Privat_konsum_lopende / BNP_lopende * 100,

      Offentlig_konsum_andel_BNP =
        Offentlig_konsum_lopende / BNP_lopende * 100,

      Investeringer_vekst =
        growth_rate(Investeringer, Aar),

      Investeringer_andel_BNP =
        Investeringer_lopende / BNP_lopende * 100,

      Lonn_per_ansatt =
        Lonn_EUR * 1e6 / Ansatte,

      Lonn_per_ansatt_nasjonal_valuta =
        Lonn_nasjonal_valuta * 1e6 / Ansatte,

      Lonnvekst =
        growth_rate(Lonn_per_ansatt_nasjonal_valuta, Aar),

      Reallonnsvekst =
        Lonnvekst - Inflasjon

    ) |>
    dplyr::ungroup()

}
