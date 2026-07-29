
standardize_kostra_keyfigures <- function(
    data,
    regions = get_kostra_regions_12134()
) {
  
  standardize_kostra_wide_table(
    data = data,
    config = kostra_table_12134(),
    indicator_metadata = kostra_indicators_12134(),
    regions = regions
  )
}

