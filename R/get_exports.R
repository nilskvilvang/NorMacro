
get_exports <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_exports",
    refresh = refresh,
    fun = function() {

      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      eksport_faste <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CLV20_MEUR",
          na_item = "P6",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Eksport = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Eksport)
        )

      eksport_lopende <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CP_MEUR",
          na_item = "P6",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Eksport_lopende = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Eksport_lopende)
        )

      eksport_faste |>
        dplyr::full_join(
          eksport_lopende,
          by = c(
            "Aar",
            "Land"
          )
        ) |>
        dplyr::arrange(
          .data$Land,
          .data$Aar
        )
    }
  )
}
