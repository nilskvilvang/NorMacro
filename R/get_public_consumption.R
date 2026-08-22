
get_public_consumption <- function(
    countries = NULL,
    refresh = FALSE
) {
  cache_get(
    name = "international_public_consumption",
    refresh = refresh,
    fun = function() {

      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      offentlig_faste <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CLV20_MEUR",
          na_item = "P3_S13",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Offentlig_konsum = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Offentlig_konsum)
        )

      offentlig_lopende <- get_eurostat_data(
        id = "nama_10_gdp",
        filters = list(
          unit = "CP_MEUR",
          na_item = "P3_S13",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Offentlig_konsum_lopende = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Offentlig_konsum_lopende)
        )

      offentlig_faste |>
        dplyr::full_join(
          offentlig_lopende,
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
