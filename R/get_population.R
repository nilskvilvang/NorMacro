
get_population <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "demo_pjan",
    filters = list(
      sex = "T",
      age = "TOTAL",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Befolkning = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Befolkning)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
