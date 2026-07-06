
testthat::test_that("normalize_series returns indexed variables", {
  result <- normalize_series(
    data = normacro,
    variables = c("BNP_Fastland", "Privat_konsum"),
    base_year = 1970
  )
  
  testthat::expect_true("Aar" %in% names(result))
  testthat::expect_equal(result$BNP_Fastland[result$Aar == 1970], 100)
})