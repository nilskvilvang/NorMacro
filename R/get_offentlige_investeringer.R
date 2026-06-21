
get_offentlige_investeringer <- function(refresh = FALSE){
  
  cache_get(
    name = "offentlige_investeringer",
    refresh = refresh,
    fun = function(){
      
      off_inv_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRMakroHov",
        query = list(
          Makrost = "bif.nr83_6",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      
      off_inv_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Offentlige_investeringer =
            as.numeric(faste_2023_priser_mill_kr)
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Offentlige_investeringer_vekst =
            (Offentlige_investeringer /
               dplyr::lag(Offentlige_investeringer) - 1) * 100
        )
    }
  )
}