
get_detaljhandel <- function(refresh = FALSE){
  
  cache_get(
    name = "detaljhandel",
    refresh = refresh,
    fun = function(){
      
      detalj_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/09296",
        query = list(
          NACE2007 = "47",
          ContentsCode = "VolumUjustert",
          Tid = "*"
        )
      )
      
      detalj_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Detaljhandel = as.numeric(volumindeks_ujustert)
        ) |>
        dplyr::filter(!is.na(Detaljhandel)) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Detaljhandel_vekst =
            (Detaljhandel / dplyr::lag(Detaljhandel) - 1) * 100
        )
    }
  )
}