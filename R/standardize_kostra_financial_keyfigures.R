
standardize_kostra_financial_keyfigures <- function(
    data,
    regions = get_kostra_regions_12143()
) {
  
  standardize_kostra_long_table(
    data = data,
    config = kostra_table_12143(),
    indicator_metadata = kostra_indicators_12143(),
    regions = regions
  )
}

