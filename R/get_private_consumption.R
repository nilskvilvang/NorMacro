
get_private_consumption <- function(
    countries = NULL,
    refresh = FALSE
) {
  cache_get(
    name = "international_private_consumption",
    refresh = refresh,
    fun = function() {

      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      privat_faste <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CLV20_MEUR",
          na_item = "P31_S14_S15",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Privat_konsum = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Privat_konsum)
        )

      privat_lopende <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CP_MEUR",
          na_item = "P31_S14_S15",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Privat_konsum_lopende = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Privat_konsum_lopende)
        )

      privat_faste |>
        dplyr::full_join(
          privat_lopende,
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
