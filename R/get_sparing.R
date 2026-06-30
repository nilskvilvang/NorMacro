get_sparing <- function(refresh = FALSE){
  
  cache_get(
    name = "sparing",
    refresh = refresh,
    fun = function(){
      
      sparing_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk03/knri/NRI",
        query = list(
          Sektor = "h140000",
          Transaksjoner = "i3591_h",
          ContentsCode = "LPriser",
          Tid = "*"
        )
      )
      
      sparing_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Husholdningssparing = as.numeric(lopende_priser)
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Husholdningssparing_vekst =
            (Husholdningssparing / dplyr::lag(Husholdningssparing) - 1) * 100
        )
    }
  )
}
