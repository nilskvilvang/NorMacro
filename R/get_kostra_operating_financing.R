
get_kostra_operating_financing <- function(
    regions,
    concepts,
    years = 2015:2025
) {
  config <- kostra_table_13553()
  
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
  
  result <- standardize_kostra_operating_financing(
    data = data
  )
  
  set_kostra_attributes(
    data = result,
    config = config
  )
}
