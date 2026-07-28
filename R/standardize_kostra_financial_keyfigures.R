
standardize_kostra_financial_keyfigures <- function(data, regions = get_kostra_regions_12143()) {
  config <- kostra_table_12143()
  indicator_metadata <- kostra_indicators_12143()
  
  concepts_in_data <- unique(data[[config$concept_code]])
  
  indicator_metadata <- indicator_metadata |>
    dplyr::filter(KOKartkap0000 %in% concepts_in_data)
  
  dimension_map <- stats::setNames(c(config$region_code, config$time_code), c("Enhet", "Aar"))
  
  indicator_map <- stats::setNames(indicator_metadata$KOKartkap0000,
                                   indicator_metadata$Variabel)
  
  value_column <- config$content_value
  
  data |>
    dplyr::rename(!!!dimension_map) |>
    dplyr::mutate(Aar = as.integer(Aar)) |>
    dplyr::filter(!is.na(.data[[value_column]])) |>
    tidyr::pivot_wider(
      names_from = dplyr::all_of(config$concept_code),
      values_from = dplyr::all_of(value_column)
    ) |>
    dplyr::rename(!!!indicator_map) |>
    dplyr::left_join(regions, by = "Enhet") |>
    dplyr::relocate(Enhet, Enhet_navn, Enhetstype, Aar) |>
    dplyr::arrange(Enhetstype, Enhet, Aar)
}
