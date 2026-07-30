
standardize_kostra_investment_financing <- function(
    data,
    regions = get_kostra_regions_12333()
) {
  
  standardize_kostra_long_table(
    data = data,
    config = kostra_table_12333(),
    indicator_metadata = kostra_indicators_12333(),
    regions = regions
  )
}