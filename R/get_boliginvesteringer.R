
get_boliginvesteringer <- function(){
  
  bolig_inv_raw <- ssb_get(
    url = "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRMakroHov",
    query = list(
      Makrost = "bif.nr8368",
      ContentsCode = "Faste",
      Tid = "*"
    )
  )
  
  bolig_inv_raw |>
    dplyr::transmute(
      Aar = as.integer(ar),
      Boliginvesteringer = as.numeric(faste_2023_priser_mill_kr)
    ) |>
    dplyr::arrange(Aar) |>
    dplyr::mutate(
      Boliginvesteringer_vekst =
        (Boliginvesteringer / dplyr::lag(Boliginvesteringer) - 1) * 100
    )
}
