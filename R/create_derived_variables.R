
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
        Arbledige_NAV / Arbeidsstyrke * 100
    )
}