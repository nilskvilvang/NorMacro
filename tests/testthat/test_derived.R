
testthat::test_that("Derived variables exist and contain data", {
  derived_vars <- metadata$Variabel[metadata$Type == "Beregnet"]
  existing <- intersect(derived_vars, names(normacro))
  
  testthat::expect_gt(length(existing), 0)
  
  non_empty <- colSums(!is.na(normacro[existing])) > 0
  
  testthat::expect_true(any(non_empty))
})