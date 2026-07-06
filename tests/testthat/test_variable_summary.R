
testthat::test_that("variable_summary returns a summary list for a valid variable", {
  
  result <- variable_summary(
    "BNP_Fastland",
    data = normacro
  )
  
  testthat::expect_true(is.list(result))
  testthat::expect_true("metadata" %in% names(result))
  testthat::expect_true("coverage" %in% names(result))
  testthat::expect_true("latest" %in% names(result))
  testthat::expect_true("growth" %in% names(result))
  
})

testthat::test_that("variable_summary supports custom correlation variables", {
  
  result <- variable_summary(
    "Inflasjon",
    data = normacro,
    correlation_variables = c(
      "Styringsrente",
      "BNP_Fastland_vekst"
    )
  )
  
  testthat::expect_true(is.list(result))
  testthat::expect_true("correlations" %in% names(result))
  
})

testthat::test_that("variable_summary throws an error for unknown variables", {
  
  testthat::expect_error(
    variable_summary(
      "Finnes_ikke",
      data = normacro
    )
  )
  
})
