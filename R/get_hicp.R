# ------------------------------------------------------------------------------
# Harmonised Index of Consumer Prices (HICP)
#
# Source:
# Eurostat
# Dataset: prc_hicp_aind
#
# Description:
# Annual Harmonised Index of Consumer Prices (HICP), all-items (CP00),
# average annual index (2015 = 100).
#
# Countries:
# NO, SE, DK, FI, DE, FR, EA20, EU27_2020
#
# Purpose:
# International comparison of consumer prices and inflation.
# ------------------------------------------------------------------------------


get_hicp <- function(countries = NULL) {
  
  if (is.null(countries)) {
    countries <- get_standard_countries()
  }
  
  eurostat::get_eurostat(
    id = "prc_hicp_aind",
    filters = list(
      unit = "INX_A_AVG",
      coicop = "CP00",
      geo = countries
    ),
    time_format = "date"
  ) |>
    dplyr::transmute(
      Aar = as.integer(format(.data$time, "%Y")),
      Land = .data$geo,
      HICP = .data$values
    ) |>
    dplyr::arrange(.data$Land, .data$Aar)
}
