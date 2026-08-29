
testthat::test_that("NorMacro test fixture has expected structure", {
  testthat::expect_true("Aar" %in% names(normacro))
  testthat::expect_true(nrow(normacro) > 100)
  testthat::expect_true(ncol(normacro) >= 75)
  testthat::expect_equal(anyDuplicated(normacro$Aar), 0)
  testthat::expect_equal(normacro$Aar, sort(normacro$Aar))
})

testthat::test_that("NorMacro builds correctly from live sources", {
  skip_if_not_live_api()

  x <- get_normacro()

  testthat::expect_true("Aar" %in% names(x))
  testthat::expect_true(nrow(x) > 100)
  testthat::expect_true(ncol(x) >= 75)
  testthat::expect_equal(anyDuplicated(x$Aar), 0)
  testthat::expect_equal(x$Aar, sort(x$Aar))
})
