
standardize_kostra_financial_foundations <- function(data) {
  
  config <- kostra_table_12364()
  
  standardize_kostra_long_table(
    data = data,
    config = config,
    indicator_metadata = kostra_indicators_12364(),
    regions = get_kostra_regions_12364()
  )
}
