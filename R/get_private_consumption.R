
get_private_consumption <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "nama_10_gdp",
    filters = list(
      unit = "CLV20_MEUR",
      na_item = "P31_S14_S15",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Privat_konsum = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Privat_konsum)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
