
get_oseax <- function(refresh = FALSE) {
  cache_get(
    name = "oseax",
    refresh = refresh,
    fun = function() {
      suppressWarnings(quantmod::getSymbols("^OSEAX", src = "yahoo", auto.assign = TRUE))
      
      data.frame(Dato = zoo::index(OSEAX), OSEAX = as.numeric(OSEAX[, "OSEAX.Adjusted"])) |>
        dplyr::filter(!is.na(OSEAX)) |>
        dplyr::mutate(Aar = as.integer(format(Dato, "%Y"))) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(OSEAX = mean(OSEAX, na.rm = TRUE), .groups = "drop") |>
        dplyr::arrange(Aar) |>
        dplyr::mutate(OSEAX_vekst =
                        (OSEAX / dplyr::lag(OSEAX) - 1) * 100)
    }
  )
}