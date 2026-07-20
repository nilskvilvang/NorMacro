
build_international_database <- function() {
  join_by <- c("Aar", "Land")
  
  hicp <- get_hicp()
  unemployment <- get_unemployment()
  population <- get_population()
  gdp <- get_gdp()
  gdp_constant <- get_gdp_constant()
  industrial_production <- get_industrial_production()
  employment <- get_employment()
  labour_force <- get_labour_force()
  government_debt <- get_government_debt()
  house_price_index <- get_house_price_index()
  retail_trade <- get_retail_trade()
  exports <- get_exports()
  imports <- get_imports()
  private_consumption <- get_private_consumption()
  public_consumption <- get_public_consumption()
  investment <- get_investment()
  interest_rate <- get_long_interest_rate()
  
  international <-
    hicp |>
    dplyr::full_join(population, by = join_by) |>
    dplyr::full_join(unemployment, by = join_by) |>
    dplyr::full_join(gdp, by = join_by) |>
    dplyr::full_join(gdp_constant, by = join_by) |>
    dplyr::full_join(industrial_production, by = join_by) |>
    dplyr::full_join(employment, by = join_by) |>
    dplyr::full_join(labour_force, by = join_by) |>
    dplyr::full_join(government_debt, by = join_by) |>
    dplyr::full_join(house_price_index, by = join_by) |>
    dplyr::full_join(retail_trade, by = join_by) |>
    dplyr::full_join(exports, by = join_by) |>
    dplyr::full_join(imports, by = join_by) |>
    dplyr::full_join(private_consumption, by = join_by) |>
    dplyr::full_join(public_consumption, by = join_by) |>
    dplyr::full_join(investment, by = join_by) |>
    dplyr::full_join(interest_rate, by = join_by) |>
    
    create_international_derived_variables()
  
  international
}

