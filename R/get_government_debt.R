

get_government_debt <- function(countries = NULL) {
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "gov_10dd_edpt1",
    filters = list(
      unit = "PC_GDP",
      sector = "S13",
      na_item = "GD",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Offentlig_gjeld_andel_BNP = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Offentlig_gjeld_andel_BNP)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
