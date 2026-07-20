
testthat::test_that("latest_observations returns latest non-missing values", {
  result <- latest_observations(data = normacro)
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_true("Variabel" %in% names(result))
  testthat::expect_true("Siste_aar" %in% names(result))
  testthat::expect_true("Siste_verdi" %in% names(result))
  
})

testthat::test_that("latest_observations supports category filtering", {
  result <- latest_observations(data = normacro, category = "Finansmarkeder")
  
  testthat::expect_true(all(result$Kategori == "Finansmarkeder"))
  
})