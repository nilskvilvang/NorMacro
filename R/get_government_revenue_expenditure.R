
get_government_revenue_expenditure <- function(
    countries = NULL,
    refresh = FALSE
) {
  cache_get(
    name = "international_government_revenue_expenditure",
    refresh = refresh,
    fun = function() {
      if (is.null(countries)) {
        countries <- get_standard_countries()
      }

      get_eurostat_data(
        id = "gov_10a_main",
        filters = list(
          unit = "PC_GDP",
          sector = "S13",
          na_item = c("TR", "TE"),
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          na_item = .data$na_item,
          values = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$values)
        ) |>
        tidyr::pivot_wider(
          names_from = "na_item",
          values_from = "values"
        ) |>
        dplyr::rename(
          Offentlige_inntekter_andel_BNP = "TR",
          Offentlige_utgifter_andel_BNP = "TE"
        ) |>
        dplyr::arrange(
          .data$Land,
          .data$Aar
        )
    }
  )
}
