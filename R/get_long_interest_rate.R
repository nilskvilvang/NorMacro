
get_long_interest_rate <- function(
    countries = c("SE", "DK", "FI", "DE", "FR", "EU27_2020")
) {
  
  get_eurostat_data(
    id = "irt_lt_mcby_a",
    filters = list(
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Statsrente_10aar = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Statsrente_10aar)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}