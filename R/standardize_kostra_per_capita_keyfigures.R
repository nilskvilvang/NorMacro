
standardize_kostra_per_capita_keyfigures <- function(
    data,
    regions = get_kostra_regions_12137()
) {
  
  standardize_kostra_long_table(
    data = data,
    config = kostra_table_12137(),
    indicator_metadata = kostra_indicators_12137(),
    regions = regions
  )
}
