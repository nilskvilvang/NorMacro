testthat::test_that("leading_indicators returns selected indicators", {
  result <- leading_indicators(normacro)
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_true("Aar" %in% names(result))
  testthat::expect_true("Konjunkturindikator" %in% names(result))
  testthat::expect_true("Rentekurve" %in% names(result))
})