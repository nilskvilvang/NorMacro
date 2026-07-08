
build_international_database <- function() {
  
  hicp <- get_hicp()
  
  unemployment <- get_unemployment()
  
  population <- get_population()
  
  gdp <- get_gdp()
  
  gdp_constant <- get_gdp_constant()
  
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
    dplyr::full_join(
      gdp_constant,
      by = c("Aar", "Land")
    ) |>
    create_international_derived_variables()
  
  international
  
}
