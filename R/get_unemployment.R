

get_unemployment <- function(countries = NULL) {
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "une_rt_a",
    filters = list(
      sex = "T",
      age = "Y15-74",
      unit = "PC_ACT",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Arbeidsledighetsrate = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Arbeidsledighetsrate)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}