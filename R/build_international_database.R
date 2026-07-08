
build_international_database <- function() {
  
  hicp <- get_hicp()
  unemployment <- get_unemployment()
  population <- get_population()
  gdp <- get_gdp()
  gdp_constant <- get_gdp_constant()
  industrial_production <- get_industrial_production()
  
  join_by <- c("Aar", "Land")
  
  international <-
    hicp |>
    dplyr::full_join(population, by = join_by) |>
    dplyr::full_join(unemployment, by = join_by) |>
    dplyr::full_join(gdp, by = join_by) |>
    dplyr::full_join(gdp_constant, by = join_by) |>
    dplyr::full_join(industrial_production, by = join_by) |>
    create_international_derived_variables()
  
  international
}
