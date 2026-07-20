
test_data <-
  tibble::tibble(
    Aar = 2015:2024,
    Faktisk = c(
      10.0,
      11.2,
      12.1,
      13.4,
      14.1,
      15.3,
      16.2,
      17.4,
      18.0,
      19.1
    ),
    Forklaringsvariabel = c(
      8.1,
      9.0,
      9.8,
      10.7,
      11.5,
      12.4,
      13.1,
      14.0,
      14.8,
      15.6
    )
  )

price_model <-
  comparison_series_regression(
    data = test_data,
    dependent_variable = "Faktisk",
    independent_variables = "Forklaringsvariabel"
  )

model_diagnosis <-
  diagnose(
    price_model
  )