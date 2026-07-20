
testthat::test_that("correlation_matrix returns a matrix for valid variables", {
  result <- correlation_matrix(variables = c("BNP_Fastland", "Privat_konsum"),
                               data = normacro)
  
  testthat::expect_true(is.matrix(result))
  testthat::expect_equal(nrow(result), 2)
  testthat::expect_equal(ncol(result), 2)
  
})

testthat::test_that("correlation_matrix supports year filtering", {
  result <- correlation_matrix(
    variables = c("Inflasjon", "Styringsrente"),
    data = normacro,
    start_year = 1990,
    end_year = 2020
  )
  
  testthat::expect_true(is.matrix(result))
  testthat::expect_equal(nrow(result), 2)
  
})

testthat::test_that("correlation_matrix throws an error for unknown variables", {
  testthat::expect_error(correlation_matrix(variables = c("Finnes_ikke"), data = normacro))
  
})
