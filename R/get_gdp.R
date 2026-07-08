
get_gdp <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "nama_10_gdp",
    filters = list(
      unit = "CP_MEUR",
      na_item = "B1G",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      BNP_lopende = .data$values
    ) |>
    dplyr::filter(!is.na(.data$BNP_lopende)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}