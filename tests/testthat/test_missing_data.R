
testthat::test_that("missing_data returns missing-value overview", {
  result <- missing_data(data = normacro)
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_true("Antall_mangler" %in% names(result))
  testthat::expect_true("Andel_mangler" %in% names(result))
  
})

testthat::test_that("missing_data supports category filtering", {
  result <- missing_data(data = normacro, category = "Konjunkturindikatorer")
  
  testthat::expect_true(all(result$Kategori == "Konjunkturindikatorer"))
  
})