
get_kostra_regions_12858 <- function() {
  
  config <- kostra_table_12858()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}

