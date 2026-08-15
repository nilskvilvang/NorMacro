
get_wages <- function(
    countries = NULL,
    refresh = FALSE
) {
  cache_get(
    name = "international_wages",
    refresh = refresh,
    fun = function() {
      
      if (is.null(countries)) {
        countries <- get_standard_countries()
      }
      
      get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = c("CP_MNAC", "CP_MEUR"),
          na_item = "D11",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          unit = .data$unit,
          value = .data$values
        ) |>
        tidyr::pivot_wider(
          id_cols = c(Aar, Land),
          names_from = unit,
          values_from = value
        ) |>
        dplyr::rename(
          Lonn_nasjonal_valuta = CP_MNAC,
          Lonn_EUR = CP_MEUR
        ) |>
        dplyr::arrange(.data$Land, .data$Aar)
    }
  )
}

