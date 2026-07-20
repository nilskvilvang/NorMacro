

get_imports <- function(countries = NULL) {
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "nama_10_gdp",
    filters = list(
      unit = "CLV20_MEUR",
      na_item = "P7",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Import = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Import)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}