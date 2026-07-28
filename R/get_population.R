
get_population <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_population",
    refresh = refresh,
    fun = function() {
      if (is.null(countries)) {
        countries <- get_standard_countries()
      }
      
      get_eurostat_data(
        id = "demo_pjan",
        filters = list(
          sex = "T",
          age = "TOTAL",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Befolkning = .data$values
        ) |>
        dplyr::filter(!is.na(.data$Befolkning)) |>
        dplyr::arrange(.data$Land, .data$Aar)
    }
  )
}
