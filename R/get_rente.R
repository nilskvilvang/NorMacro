
get_rente <- function(refresh = FALSE){
  
  cache_get(
    name = "rente",
    refresh = refresh,
    fun = function(){
      
      url_rente <- "https://data.norges-bank.no/api/data/IR/M.KPRA..?format=csv&lastNObservations=1200&locale=no&bom=include"
      
      rente_raw <- rio::import(
        url_rente,
        format = "csv"
      )
      
      rente_raw |>
        dplyr::mutate(
          Aar = as.integer(substr(TIME_PERIOD, 1, 4)),
          Styringsrente = readr::parse_number(
            as.character(OBS_VALUE),
            locale = readr::locale(decimal_mark = ",")
          )
        ) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Styringsrente = mean(Styringsrente, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}