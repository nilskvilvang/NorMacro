
get_house_price_index <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "prc_hpi_a",
    filters = list(
      purchase = "TOTAL",
      unit = "I15_A_AVG",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Boligprisindeks = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Boligprisindeks)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
