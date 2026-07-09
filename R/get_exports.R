
get_exports <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "nama_10_gdp",
    filters = list(
      unit = "CLV20_MEUR",
      na_item = "P6",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Eksport = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Eksport)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}