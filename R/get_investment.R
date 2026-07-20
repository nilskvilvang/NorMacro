
get_investment <- function(countries = NULL) {
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "nama_10_gdp",
    filters = list(
      unit = "CLV20_MEUR",
      na_item = "P51G",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Investeringer = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Investeringer)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
