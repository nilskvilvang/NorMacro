
get_kostra_regions_12135 <- function() {
  config <- kostra_table_12135()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}