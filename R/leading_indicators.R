
leading_indicators <- function(data = NULL) {
  if (is.null(data)) {
    data <- suppressMessages(get_normacro())
  }
  
  indicators <- c(
    "Aar",
    "Industriproduksjon",
    "Byggeaktivitet",
    "Tjenesteproduksjon",
    "Detaljhandel",
    "Konjunkturindikator",
    "Kapasitetsutnytting",
    "Ressursknapphet",
    "Ordrebeholdning",
    "Arbledighetsrate_NAV",
    "Styringsrente",
    "Pengemarkedsrente_3mnd",
    "Statsrente_10aar",
    "Rentekurve"
  )
  
  existing <- intersect(indicators, names(data))
  
  result <- data |>
    dplyr::select(dplyr::all_of(existing))
  
  indicator_cols <- setdiff(names(result), "Aar")
  
  result |>
    dplyr::filter(rowSums(!is.na(dplyr::pick(
      dplyr::all_of(indicator_cols)
    ))) > 0)
}