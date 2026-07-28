
get_kostra_regions_12143 <- function() {
  config <- kostra_table_12143()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}
