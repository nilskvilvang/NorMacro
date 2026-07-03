
get_tjenesteproduksjon <- function(refresh = FALSE){
  
  cache_get(
    name = "tjenesteproduksjon",
    refresh = refresh,
    fun = function(){
      
      tjeneste_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/vt/vt01/pit/Pit01",
        query = list(
          NACE2007 = "H-J+M-N",
          ContentsCode = "ProdIndKalJus",
          Tid = "*"
        )
      )
      
      tjeneste_raw |>
        dplyr::transmute(
          Aar = as.integer(substr(maned, 1, 4)),
          Tjenesteproduksjon = as.numeric(produksjonsindeks_kalenderjustert)
        ) |>
        dplyr::filter(!is.na(Tjenesteproduksjon)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Tjenesteproduksjon = mean(Tjenesteproduksjon, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Tjenesteproduksjon_vekst =
            (Tjenesteproduksjon / dplyr::lag(Tjenesteproduksjon) - 1) * 100
        )
    }
  )
}