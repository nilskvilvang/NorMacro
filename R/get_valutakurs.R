
get_valutakurs <- function(refresh = FALSE){
  
  cache_get(
    name = "valutakurs",
    refresh = refresh,
    fun = function(){
      
      url_valuta <- paste0(
        "https://data.norges-bank.no/api/data/",
        "EXR/A.I44.NOK.SP?",
        "format=csv&lastNObservations=100&locale=no"
      )
      
      valuta_raw <- rio::import(
        url_valuta,
        format = "csv"
      )
      
      valuta_raw |>
        dplyr::transmute(
          Aar = as.integer(TIME_PERIOD),
          Valutakurs_I44 = readr::parse_number(
            OBS_VALUE,
            locale = readr::locale(decimal_mark = ",")
          )
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Valutakurs_I44_vekst =
            (Valutakurs_I44 / dplyr::lag(Valutakurs_I44) - 1) * 100
        )
    }
  )
}