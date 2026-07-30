
get_kostra_regions_13553 <- function() {
  config <- kostra_table_13553()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}