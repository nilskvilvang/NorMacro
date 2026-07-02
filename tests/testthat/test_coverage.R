
testthat::test_that("coverage returns variable coverage", {
  result <- coverage(normacro)
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_true("Variabel" %in% names(result))
  testthat::expect_true("Startaar_data" %in% names(result))
  testthat::expect_true("Sluttaar_data" %in% names(result))
  testthat::expect_equal(nrow(result), ncol(normacro) - 1)
})