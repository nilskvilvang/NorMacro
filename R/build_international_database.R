
build_international_database <- function(refresh = FALSE) {
  join_by <- c("Aar", "Land")
  
  hicp <- get_hicp(refresh = refresh)
  unemployment <- get_unemployment(refresh = refresh)
  population <- get_population(refresh = refresh)
  gdp <- get_gdp(refresh = refresh)
  gdp_constant <- get_gdp_constant(refresh = refresh)
  industrial_production <- get_industrial_production(refresh = refresh)
  employment <- get_employment(refresh = refresh)
  employees <- get_employees(refresh = refresh)
  labour_force <- get_labour_force(refresh = refresh)
  government_debt <- get_government_debt(refresh = refresh)
  budget_balance <- get_budget_balance(refresh = refresh)
  house_price_index <- get_house_price_index(refresh = refresh)
  retail_trade <- get_retail_trade(refresh = refresh)
  exports <- get_exports(refresh = refresh)
  imports <- get_imports(refresh = refresh)
  private_consumption <- get_private_consumption(refresh = refresh)
  public_consumption <- get_public_consumption(refresh = refresh)
  investment <- get_investment(refresh = refresh)
  interest_rate <- get_long_interest_rate(refresh = refresh)
  short_interest_rate <- get_short_interest_rate(refresh = refresh)
  wages <- get_wages(refresh = refresh)
  current_account <- get_current_account_balance(refresh = refresh
  )
  
  international <-
    hicp |>
    dplyr::full_join(population, by = join_by) |>
    dplyr::full_join(unemployment, by = join_by) |>
    dplyr::full_join(gdp, by = join_by) |>
    dplyr::full_join(gdp_constant, by = join_by) |>
    dplyr::full_join(industrial_production, by = join_by) |>
    dplyr::full_join(employment, by = join_by) |>
    dplyr::full_join(employees, by = join_by) |>
    dplyr::full_join(labour_force, by = join_by) |>
    dplyr::full_join(government_debt, by = join_by) |>
    dplyr::full_join(budget_balance, by = join_by) |>
    dplyr::full_join(house_price_index, by = join_by) |>
    dplyr::full_join(retail_trade, by = join_by) |>
    dplyr::full_join(exports, by = join_by) |>
    dplyr::full_join(imports, by = join_by) |>
    dplyr::full_join(current_account, by = join_by) |>
    dplyr::full_join(private_consumption, by = join_by) |>
    dplyr::full_join(public_consumption, by = join_by) |>
    dplyr::full_join(investment, by = join_by) |>
    dplyr::full_join(interest_rate, by = join_by) |>
    dplyr::full_join(short_interest_rate, by = join_by) |>
    dplyr::full_join(wages, by = join_by) |>
    create_international_derived_variables()
  
  international
}

