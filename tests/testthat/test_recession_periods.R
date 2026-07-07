
testthat::test_that("recession_periods returns a data frame", {
  
  result <- recession_periods(data = normacro)
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_true("Startaar" %in% names(result))
  testthat::expect_true("Sluttaar" %in% names(result))
  testthat::expect_true("Lengde" %in% names(result))
  
})

testthat::test_that("recession_periods supports multiple phases", {
  
  result <- recession_periods(
    data = normacro,
    phases = c("Nedgang", "Svak vekst")
  )
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_true(all(result$Fase %in% c("Nedgang", "Svak vekst")))
  
})