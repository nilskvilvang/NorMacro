
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
        Statlige_utgifter / Offentlige_utgifter * 100
    )
}