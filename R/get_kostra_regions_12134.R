
get_kostra_regions_12134 <- function() {
  config <- kostra_table_12134()
  
  get_kostra_regions(
    url = config$url,
    region_code = config$region_code
  )
}

