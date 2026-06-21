

old_wd <- getwd()
setwd("../..")
source("source_all.R")

normacro <- get_normacro()
metadata <- get_metadata()

setwd(old_wd)

testthat::test_that("NorMacro builds correctly", {
  testthat::expect_true("Aar" %in% names(normacro))
  testthat::expect_true(nrow(normacro) > 100)
  testthat::expect_true(ncol(normacro) >= 55)
  testthat::expect_equal(anyDuplicated(normacro$Aar), 0)
  testthat::expect_equal(normacro$Aar, sort(normacro$Aar))
})

testthat::test_that("All variables have metadata", {
  undocumented <- setdiff(names(normacro), c(metadata$Variabel, "Aar"))
  
  testthat::expect_equal(undocumented, character(0))
})

test_that("Productivity variables contain data", {
  normacro <- get_normacro()
  
  expect_gt(sum(!is.na(normacro$Arbeidsproduktivitet)), 0)
  
  expect_gt(sum(!is.na(normacro$BNP_Fastland_per_innbygger)), 0)
  
})