
get_fastlandsinvesteringer <- function(refresh = FALSE){
  
  cache_get(
    name = "fastlandsinvesteringer",
    refresh = refresh,
    fun = function(){
      
      fastland_inv_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRInvestKapital",
        query = list(
          NACE = "nr23_6fn",
          ContentsCode = "BIF2",
          Tid = "*"
        )
      )
      
      fastland_inv_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Fastlandsinvesteringer =
            as.numeric(bruttoinvestering_i_fast_realkapital_faste_2023_priser_mill_kr)
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Fastlandsinvesteringer_vekst =
            (Fastlandsinvesteringer /
               dplyr::lag(Fastlandsinvesteringer) - 1) * 100
        )
    }
  )
}
