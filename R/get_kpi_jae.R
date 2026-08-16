
get_kpi_jae <- function(refresh = FALSE) {
  cache_get(
    name = "kpi_jae",
    refresh = refresh,
    fun = function() {
      
      index <- suppressWarnings(
        ssb_get(
          url = "https://data.ssb.no/api/v0/no/table/14707",
          query = list(
            KPIavledetSerie = "KPI-JAE",
            ContentsCode = "KPIJaar",
            Tid = "*"
          )
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          KPI_JAE = .data$indeks_2025_100
        ) |>
        dplyr::filter(
          !is.na(.data$KPI_JAE)
        )
      
      inflation <- suppressWarnings(
        ssb_get(
          url = "https://data.ssb.no/api/v0/no/table/14707",
          query = list(
            KPIavledetSerie = "KPI-JAE",
            ContentsCode = "Aarsendring",
            Tid = "*"
          )
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(.data$ar),
          Inflasjon_JAE = .data$arsendring_prosent
        ) |>
        dplyr::filter(
          !is.na(.data$Inflasjon_JAE)
        )
      
      dplyr::full_join(
        index,
        inflation,
        by = "Aar"
      ) |>
        dplyr::arrange(.data$Aar)
    }
  )
}

