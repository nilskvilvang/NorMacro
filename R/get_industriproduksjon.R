
get_industriproduksjon <- function(refresh = FALSE){
  
  cache_get(
    name = "industriproduksjon",
    refresh = refresh,
    fun = function(){
      
      industri_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk02/pii/ProdIndexIndNaVa",
        query = list(
          PKoder = "P105",
          ContentsCode = "ProdInd",
          Tid = "*"
        )
      )
      
      industri_raw |>
        dplyr::transmute(
          Aar = as.integer(ar),
          Industriproduksjon = as.numeric(produksjonsindeks)
        ) |>
        dplyr::filter(!is.na(Industriproduksjon)) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Industriproduksjon_vekst =
            (Industriproduksjon / dplyr::lag(Industriproduksjon) - 1) * 100
        )
    }
  )
}