
get_employment <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "nama_10_pe",
    filters = list(
      unit = "THS_PER",
      na_item = "EMP_DC",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Sysselsatte = .data$values * 1000
    ) |>
    dplyr::filter(!is.na(.data$Sysselsatte)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}

