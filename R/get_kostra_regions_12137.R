
get_kostra_regions_12137 <- function() {
  config <- kostra_table_12137()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}
