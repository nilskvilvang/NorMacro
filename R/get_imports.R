
get_imports <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_imports",
    refresh = refresh,
    fun = function() {

      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      import_faste <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CLV20_MEUR",
          na_item = "P7",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Import = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Import)
        )

      import_lopende <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CP_MEUR",
          na_item = "P7",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Import_lopende = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Import_lopende)
        )

      import_faste |>
        dplyr::full_join(
          import_lopende,
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
