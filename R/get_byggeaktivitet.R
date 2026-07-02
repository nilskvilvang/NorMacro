
get_byggeaktivitet <- function(refresh = FALSE){
  
  cache_get(
    name = "byggeaktivitet",
    refresh = refresh,
    fun = function(){
      
      bygg_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/bb/bb02/bygganlprod/ProIndByggAnl03",
        query = list(
          NACE = "F",
          ContentsCode = "Produksjonsindeks",
          Tid = "*"
        )
      )
      
      bygg_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Byggeaktivitet = as.numeric(produksjonsindeks_ujustert)
        ) |>
        dplyr::filter(!is.na(Byggeaktivitet)) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Byggeaktivitet_vekst =
            (Byggeaktivitet / dplyr::lag(Byggeaktivitet) - 1) * 100
        )
    }
  )
}

