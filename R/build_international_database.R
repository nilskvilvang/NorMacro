
build_international_database <- function() {
  
  hicp <- get_hicp()
  
  unemployment <- get_unemployment()
  
  population <- get_population()
  
  gdp <- get_gdp()
  
  join_by <- c("Aar", "Land")
  
  international <-
    hicp |>
    dplyr::full_join(
      population,
      by = c("Aar", "Land")
    ) |>
    dplyr::full_join(
      unemployment,
      by = c("Aar", "Land")
    ) |>
    dplyr::full_join(
      gdp,
      by = c("Aar", "Land")
    ) |>
    create_international_derived_variables()
  
  international
  
}
