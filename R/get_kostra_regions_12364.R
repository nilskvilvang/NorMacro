
get_kostra_regions_12364 <- function() {
  config <- kostra_table_12364()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}