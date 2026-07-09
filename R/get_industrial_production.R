
get_industrial_production <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "sts_inpr_a",
    filters = list(
      unit = "I15",
      s_adj = "CA",
      nace_r2 = "C",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Industriproduksjon = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Industriproduksjon)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}