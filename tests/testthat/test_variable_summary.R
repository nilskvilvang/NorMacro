
testthat::test_that("variable_summary returns a summary list for a valid variable", {
  result <- variable_summary("BNP_Fastland", data = normacro)
  
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
    correlation_variables = c("Styringsrente", "BNP_Fastland_vekst")
  )
  
  testthat::expect_true(is.list(result))
  testthat::expect_true("correlations" %in% names(result))
  
})

testthat::test_that("variable_summary throws an error for unknown variables", {
  testthat::expect_error(variable_summary("Finnes_ikke", data = normacro))
  
})

test_that("variable_summary bruker riktig analysetype", {
  level_result <- variable_summary("Befolkning")
  index_result <- variable_summary("KPI")
  rate_result <- variable_summary("Inflasjon")
  
  expect_true(!is.null(level_result$growth))
  expect_null(level_result$rate_summary)
  
  expect_true(!is.null(index_result$growth))
  expect_null(index_result$rate_summary)
  
  expect_null(rate_result$growth)
  expect_true(!is.null(rate_result$rate_summary))
})

test_that("internasjonale rateserier oppsummeres som rate", {
  result <- variable_summary(
    "BNP_vekst",
    country = "SE"
  )
  
  expect_null(result$growth)
  expect_true(!is.null(result$rate_summary))
  expect_equal(result$metadata$Analyse_type[[1]], "rate")
})
