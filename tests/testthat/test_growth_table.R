
testthat::test_that("growth_table returns one row per selected variable", {
  result <- growth_table(variables = c("BNP_Fastland", "Privat_konsum"),
                         data = normacro)
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_equal(nrow(result), 2)
  testthat::expect_true("Siste_aar" %in% names(result))
  testthat::expect_true("Siste_verdi" %in% names(result))
  
})

testthat::test_that("growth_table supports custom periods", {
  result <- growth_table(
    variables = c("BNP_Fastland"),
    data = normacro,
    periods = c(1, 3)
  )
  
  testthat::expect_true("Vekst_1aar" %in% names(result))
  testthat::expect_true("Vekst_3aar" %in% names(result))
  testthat::expect_true("CAGR_3aar" %in% names(result))
  
})

testthat::test_that("growth_table throws an error for unknown variables", {
  testthat::expect_error(growth_table(variables = c("Finnes_ikke"), data = normacro))
  
})
