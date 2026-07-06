
testthat::test_that("compare_series returns a ggplot object for valid variables", {
  
  p <- compare_series(
    variables = c("BNP_Fastland", "Privat_konsum"),
    data = normacro
  )
  
  testthat::expect_s3_class(p, "ggplot")
  
})

testthat::test_that("compare_series supports normalize = FALSE", {
  
  p <- compare_series(
    variables = c("Inflasjon", "Styringsrente"),
    data = normacro,
    normalize = FALSE
  )
  
  testthat::expect_s3_class(p, "ggplot")
  
})

testthat::test_that("compare_series supports complete_cases = TRUE", {
  
  p <- compare_series(
    variables = c(
      "Inflasjon",
      "Styringsrente",
      "Pengemarkedsrente_3mnd"
    ),
    data = normacro,
    normalize = FALSE,
    complete_cases = TRUE
  )
  
  testthat::expect_s3_class(p, "ggplot")
  
})

testthat::test_that("compare_series throws an error for unknown variables", {
  
  testthat::expect_error(
    
    compare_series(
      variables = c("Finnes_ikke"),
      data = normacro
    )
    
  )
  
})