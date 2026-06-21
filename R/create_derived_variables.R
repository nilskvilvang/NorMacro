
create_derived_variables <- function(data){
  
  data |>
    dplyr::arrange(Aar) |>
    dplyr::mutate(
      Befolkningsvekst =
        (Befolkning / dplyr::lag(Befolkning) - 1) * 100,
      
      Reallonnsvekst =
        Lonnvekst - Inflasjon,
      
      Arbeidsstyrkeandel =
        Arbeidsstyrke / Befolkning * 100,
      
      Arbledige_andel_arbeidsstyrke_NAV =
        Arbledige_NAV / Arbeidsstyrke * 100,
      
      Offentlig_gjeld_andel_BNP =
        Offentlig_gjeld / BNP_lopende * 100,
      
      Offentlig_nettofordringer_andel_BNP =
        Offentlig_nettofordringer / BNP_lopende * 100,
      
      Kommunal_utgiftsandel =
        Kommunale_utgifter / Offentlige_utgifter * 100,
      
      Statlig_utgiftsandel =
        Statlige_utgifter / Offentlige_utgifter * 100,
      
      Boliginvesteringer_andel_BNP =
        Boliginvesteringer / BNP_Fastland * 100,
      
      BNP_Fastland_per_innbygger =
        BNP_Fastland / Befolkning,
      
      BNP_Fastland_per_innbygger_vekst =
        (BNP_Fastland_per_innbygger /
           dplyr::lag(BNP_Fastland_per_innbygger) - 1) * 100,
      
      BNP_lopende_per_innbygger =
        BNP_lopende / Befolkning,
      
      Arbeidsproduktivitet =
        BNP_Fastland / Sysselsatte,
      
      Offentlige_investeringer_andel_BNP =
        Offentlige_investeringer / BNP_Fastland * 100,
      
    ) |>
    
    dplyr::mutate(
      Produktivitetsvekst =
        (Arbeidsproduktivitet / dplyr::lag(Arbeidsproduktivitet) - 1) * 100
    )
}
