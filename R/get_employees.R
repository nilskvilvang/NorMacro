
get_employees <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_employees",
    refresh = refresh,
    fun = function() {
      
      if (is.null(countries)) {
        countries <- get_standard_countries()
      }
      
      get_eurostat_data(
        id = "nama_10_pe",
        filters = list(
          unit = "THS_PER",
          na_item = "SAL_DC",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Ansatte = .data$values * 1000
        ) |>
        dplyr::filter(
          !is.na(.data$Ansatte)
        ) |>
        dplyr::arrange(
          .data$Land,
          .data$Aar
        )
    }
  )
}
