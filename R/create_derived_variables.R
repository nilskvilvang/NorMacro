
create_derived_variables <- function(data) {
  data |>
    dplyr::arrange(Aar) |>
    dplyr::mutate(
      Befolkningsvekst =
        (Befolkning / dplyr::lag(Befolkning) - 1) * 100,

      Reallonnsvekst =
        Lonnvekst - Inflasjon,

      Arbeidsledige_AKU =
        Arbeidsstyrke - Sysselsatte,

      Arbeidsledighetsrate_AKU =
        Arbeidsledige_AKU / Arbeidsstyrke * 100,

      Offentlig_gjeld_andel_BNP =
        Offentlig_gjeld / BNP_lopende * 100,

      Offentlig_nettofordringer_andel_BNP =
        Offentlig_nettofordringer / BNP_lopende * 100,

      Offentlige_inntekter_andel_BNP =
        Offentlige_inntekter / BNP_lopende * 100,

      Offentlige_utgifter_andel_BNP =
        Offentlige_utgifter / BNP_lopende * 100,

      Nettofinansinvestering_andel_BNP =
        Nettofinansinvestering / BNP_lopende * 100,

      Kommunal_utgiftsandel =
        Kommunale_utgifter / Offentlige_utgifter * 100,

      Statlig_utgiftsandel =
        Statlige_utgifter / Offentlige_utgifter * 100,

      Boliginvesteringer_andel_BNP =
        Boliginvesteringer_lopende / BNP_lopende * 100,

      BNP_Fastland_per_innbygger =
        BNP_Fastland / Befolkning,

      BNP_Fastland_per_innbygger_vekst =
        (
          BNP_Fastland_per_innbygger /
            dplyr::lag(BNP_Fastland_per_innbygger) - 1
        ) * 100,

      BNP_lopende_per_innbygger =
        BNP_lopende / Befolkning,

      Arbeidsproduktivitet =
        BNP_Fastland / Sysselsatte,

      Offentlige_investeringer_andel_BNP =
        Offentlige_investeringer_lopende / BNP_lopende * 100,

      Privat_konsum_andel_BNP =
        Privat_konsum_lopende / BNP_lopende * 100,

      Offentlig_konsum_andel_BNP =
        Offentlig_konsum_lopende / BNP_lopende * 100,

      Husholdningssparing_andel_disponibel_inntekt =
        Husholdningssparing / Disponibel_inntekt_husholdninger * 100,

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

      Driftsbalanse_andel_BNP =
        Driftsbalanse / BNP_lopende * 100,

      Fastlandsinvesteringer_andel_BNP_Fastland =
        Fastlandsinvesteringer_lopende /
        BNP_Fastland_lopende * 100,

      Investeringer_andel_BNP =
        Investeringer_lopende / BNP_lopende * 100,

      Netto_IIP_andel_BNP =
        .data$Netto_IIP / .data$BNP_lopende * 100,

      Rentekurve =
        Statsrente_10aar - Styringsrente
    ) |>
    dplyr::mutate(
      Produktivitetsvekst =
        (
          Arbeidsproduktivitet /
            dplyr::lag(Arbeidsproduktivitet) - 1
        ) * 100
    )
}
