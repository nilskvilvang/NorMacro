

get_unemployment <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "une_rt_a",
    filters = list(
      sex = "T",
      age = "Y15-74",
      unit = "PC_ACT",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Arbeidsledighetsrate = .data$values
    ) |>
    dplyr::arrange(.data$Land, .data$Aar)
}