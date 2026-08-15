
get_kostra_regions_12333 <- function() {
  config <- kostra_table_12333()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}
