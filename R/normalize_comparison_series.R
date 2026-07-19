
normalize.comparison_series <- function(
    x,
    base_year = NULL,
    ...
) {
  
  index(
    x,
    base_year = base_year,
    base_value = 100
  )
}
