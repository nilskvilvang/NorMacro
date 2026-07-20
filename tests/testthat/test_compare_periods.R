
testthat::test_that("compare_periods returns one row per selected variable", {
  result <- compare_periods(
    variables = c("BNP_Fastland", "Privat_konsum"),
    start_year = 2010,
    end_year = 2025,
    data = normacro
  )
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_equal(nrow(result), 2)
  
})

testthat::test_that("compare_periods returns expected columns", {
  result <- compare_periods(
    variables = "BNP_Fastland",
    start_year = 2010,
    end_year = 2025,
    data = normacro
  )
  
  testthat::expect_true("Endring" %in% names(result))
  testthat::expect_true("Endring_prosent" %in% names(result))
  
})

testthat::test_that("compare_periods throws an error for unknown variables", {
  testthat::expect_error(
    compare_periods(
      variables = "Finnes_ikke",
      start_year = 2010,
      end_year = 2025,
      data = normacro
    )
    
  )
  
})