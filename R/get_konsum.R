get_konsum <- function(refresh = FALSE){
  
  cache_get(
    name = "konsum",
    refresh = refresh,
    fun = function(){
      
      url <- "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRMakroHov"
      
      privat_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koh.nr61_",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      
      offentlig_raw <- ssb_get(
        url = url,
        query = list(
          Makrost = "koo.nroff",
          ContentsCode = "Faste",
          Tid = "*"
        )
      )
      
      privat <- privat_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Privat_konsum = as.numeric(faste_2023_priser_mill_kr)
        )
      
      offentlig <- offentlig_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Offentlig_konsum = as.numeric(faste_2023_priser_mill_kr)
        )
      
      privat |>
        dplyr::left_join(offentlig, by = "Aar") |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Privat_konsum_vekst =
            (Privat_konsum / dplyr::lag(Privat_konsum) - 1) * 100,
          
          Offentlig_konsum_vekst =
            (Offentlig_konsum / dplyr::lag(Offentlig_konsum) - 1) * 100
        )
    }
  )
}
