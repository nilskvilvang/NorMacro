
standardize_kostra_operating_financing <- function(
    data,
    regions = get_kostra_regions_13553()
) {
  
  standardize_kostra_long_table(
    data = data,
    config = kostra_table_13553(),
    indicator_metadata = kostra_indicators_13553(),
    regions = regions
  )
}
