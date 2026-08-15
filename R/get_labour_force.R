
get_labour_force <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_labour_force",
    refresh = refresh,
    fun = function() {
      
      if (is.null(countries)) {
        countries <- get_standard_countries()
      }
      
      get_eurostat_data(
        id = "lfsi_emp_a",
        filters = list(
          indic_em = "ACT",
          unit = c("THS_PER", "PC_POP"),
          sex = "T",
          age = "Y15-64",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          unit = .data$unit,
          values = .data$values
        ) |>
        tidyr::pivot_wider(
          names_from = "unit",
          values_from = "values"
        ) |>
        dplyr::transmute(
          Aar,
          Land,
          Arbeidsstyrke = .data$THS_PER * 1000,
          Arbeidsstyrkeandel = .data$PC_POP
        ) |>
        dplyr::arrange(.data$Land, .data$Aar)
    }
  )
}

