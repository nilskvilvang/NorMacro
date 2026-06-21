
get_oljepris <- function(refresh = FALSE){
  
  cache_get(
    name = "oljepris",
    refresh = refresh,
    fun = function(){
      
      quantmod::getSymbols(
        "DCOILBRENTEU",
        src = "FRED",
        auto.assign = TRUE
      )
      
      data.frame(
        Dato = zoo::index(DCOILBRENTEU),
        Oljepris_USD = as.numeric(DCOILBRENTEU[, 1])
      ) |>
        dplyr::filter(!is.na(Oljepris_USD)) |>
        dplyr::mutate(
          Aar = as.integer(format(Dato, "%Y"))
        ) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Oljepris_USD = mean(Oljepris_USD, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(
          Oljeprisvekst =
            (Oljepris_USD / dplyr::lag(Oljepris_USD) - 1) * 100
        )
    }
  )
}
