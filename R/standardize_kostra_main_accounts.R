
standardize_kostra_main_accounts <- function(
    data,
    regions = get_kostra_regions_12858()
) {
  
  standardize_kostra_long_table(
    data = data,
    config = kostra_table_12858(),
    indicator_metadata = kostra_indicators_12858(),
    regions = regions
  )
  
}


