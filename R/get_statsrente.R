
get_statsrente <- function(refresh = FALSE) {
  cache_get(
    name = "statsrente",
    refresh = refresh,
    fun = function() {
      url_statsrente <- paste0(
        "https://data.norges-bank.no/api/data/",
        "GOVT_GENERIC_RATES/A.10Y.GBON.?",
        "format=csv&lastNObservations=100&locale=no&bom=include"
      )
      
      statsrente_raw <- rio::import(url_statsrente, format = "csv")
      
      statsrente_raw |>
        dplyr::transmute(
          Aar = as.integer(TIME_PERIOD),
          Statsrente_10aar = readr::parse_number(OBS_VALUE, locale = readr::locale(decimal_mark = ","))
        ) |>
        dplyr::arrange(Aar)
    }
  )
}