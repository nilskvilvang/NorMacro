
get_kostra_financial_keyfigures <- function(
    regions,
    concepts,
    years = 2015:2025
) {
  config <- kostra_table_12143()
  
  query <- stats::setNames(
    list(
      regions,
      concepts,
      config$content_value,
      years
    ),
    c(
      config$region_code,
      config$concept_code,
      config$content_code,
      config$time_code
    )
  )
  
  get_kostra_table(
    url = config$url,
    query = query
  )
}
