
standardize_kostra_debt_keyfigures <- function(
    data,
    regions = get_kostra_regions_12135()
) {
  
  standardize_kostra_long_table(
    data = data,
    config = kostra_table_12135(),
    indicator_metadata = kostra_indicators_12135(),
    regions = regions
  )
}
