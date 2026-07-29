
get_kostra_main_accounts <- function(
    regions,
    concepts,
    years = 2015:2025
) {
  
  config <- kostra_table_12858()
  
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
  
  data <- get_kostra_table(
    url = config$url,
    query = query
  )
  
  standardize_kostra_main_accounts(
    data = data
  )
  
}

