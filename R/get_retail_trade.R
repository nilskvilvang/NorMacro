
get_retail_trade <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  get_eurostat_data(
    id = "sts_trtu_a",
    filters = list(
      unit = "I15",
      indic_bt = "VOL_SLS",
      nace_r2 = "G47",
      s_adj = "CA",
      geo = countries
    )
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      Detaljhandel = .data$values
    ) |>
    dplyr::filter(!is.na(.data$Detaljhandel)) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
