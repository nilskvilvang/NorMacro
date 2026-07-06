
testthat::test_that("overview prints a database summary", {
  result <- overview(normacro, print = FALSE)
  
  testthat::expect_true(is.list(result))
  testthat::expect_true("categories" %in% names(result))
  testthat::expect_equal(result$n_variables, ncol(normacro) - 1)
  testthat::expect_gt(result$n_categories, 0)
})
