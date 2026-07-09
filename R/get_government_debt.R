
get_government_debt <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "gov_10dd_edpt1",
    filters = list(
      unit = "PC_GDP",
      sector = "S13",
      na_item = "GD",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Offentlig_gjeld_andel_BNP = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Offentlig_gjeld_andel_BNP)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}