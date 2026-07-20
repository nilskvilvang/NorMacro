
testthat::test_that("search_variables returns metadata rows", {
  result <- search_variables("konsum")
  
  testthat::expect_s3_class(result, "data.frame")
  testthat::expect_gt(nrow(result), 0)
  testthat::expect_true(all(c("Variabel", "Beskrivelse", "Kilde") %in% names(result)))
})

testthat::test_that("describe_variable returns one metadata row", {
  variable <- metadata$Variabel[1]
  
  description <- describe_variable(variable, print = FALSE)
  
  testthat::expect_s3_class(description, "data.frame")
  testthat::expect_equal(nrow(description), 1)
  testthat::expect_equal(description$Variabel, variable)
})