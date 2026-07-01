
testthat::test_that("NorMacro builds correctly", {
  testthat::expect_true("Aar" %in% names(normacro))
  testthat::expect_true(nrow(normacro) > 100)
  testthat::expect_true(ncol(normacro) >= 75)
  testthat::expect_equal(anyDuplicated(normacro$Aar), 0)
  testthat::expect_equal(normacro$Aar, sort(normacro$Aar))
})