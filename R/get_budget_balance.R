
get_budget_balance <- function(countries = NULL, refresh = FALSE) {
  cache_get(
    name = "international_budget_balance",
    refresh = refresh,
    fun = function() {
      if (is.null(countries)) {
        countries <- get_standard_countries()
        }
      get_eurostat_data(
        id = "gov_10dd_edpt1",
        filters = list(
          unit = "PC_GDP",
          sector = "S13",
          na_item = "B9",
          geo = countries
        )
      ) |>
        dplyr::transmute(
          Aar = as.integer(format(.data$time, "%Y")),
          Land = .data$geo,
          Budsjettbalanse = .data$values
        ) |>
        dplyr::filter(
          !is.na(.data$Budsjettbalanse)
        ) |>
        dplyr::arrange(
          .data$Land,
          .data$Aar
        )
    }
  )
}
