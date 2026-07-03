
leading_indicators <- function(data = NULL){
  
  if(is.null(data)){
    data <- get_normacro()
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
  
  data |>
    dplyr::select(dplyr::all_of(existing))
}