
get_labour_force <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "lfsi_emp_a",
    filters = list(
      indic_em = "ACT",
      unit = "THS_PER",
      sex = "T",
      age = "Y15-64",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Arbeidsstyrke = .data$values * 1000
    ) |>
    dplyr::filter(!is.na(.data$Arbeidsstyrke)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
