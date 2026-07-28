
get_kostra_keyfigures <- function(
    regions,
    years = 2015:2025
) {
  config <- kostra_table_12134()
  
  query <- stats::setNames(
    list(
      regions,
      kostra_indicators_12134()$ContentsCode,
      years
    ),
    c(
      config$region_code,
      config$indicator_code,
      config$time_code
    )
  )
  
  get_kostra_table(
    url = config$url,
    query = query
  )
}

