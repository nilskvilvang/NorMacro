
get_gdp_constant <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "nama_10_gdp",
    filters = list(
      unit = "CLV20_MEUR",
      na_item = "B1G",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      BNP_faste_priser = .data$values
    ) |>
    dplyr::filter(!is.na(.data$BNP_faste_priser)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
