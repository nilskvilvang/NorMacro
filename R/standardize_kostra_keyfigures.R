
standardize_kostra_keyfigures <- function(data, regions = get_kostra_regions_12134()) {
  config <- kostra_table_12134()
  indicator_metadata <- kostra_indicators_12134()
  
  dimension_map <- stats::setNames(c(config$region_code, config$time_code), c("Enhet", "Aar"))
  
  indicator_map <- stats::setNames(indicator_metadata$ContentsCode,
                                   indicator_metadata$Variabel)
  
  indicator_names <- indicator_metadata$Variabel
  
  data |>
    dplyr::rename(!!!dimension_map, !!!indicator_map) |>
    dplyr::mutate(Aar = as.integer(Aar)) |>
    dplyr::left_join(regions, by = "Enhet") |>
    dplyr::filter(dplyr::if_any(dplyr::all_of(indicator_names), ~ !is.na(.x))) |>
    dplyr::relocate(Enhet, Enhet_navn, Enhetstype, Aar) |>
    dplyr::arrange(Enhetstype, Enhet, Aar)
}

