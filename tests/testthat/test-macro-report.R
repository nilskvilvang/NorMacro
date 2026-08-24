
test_that("macro_report validates year", {
  expect_error(macro_report(year = "2025"), "`year`")
  
  expect_error(macro_report(year = c(2024, 2025)), "`year`")
  
  expect_error(macro_report(year = NA_real_), "`year`")
  
  expect_error(macro_report(year = 1960), "BNP Fastland vekst mangler")
})


test_that("macro_report allows years with partial data", {
  report <- macro_report(year = 1971)
  
  expect_s3_class(report, "normacro_report")
  
  expect_equal(report$year, 1971L)
})


test_that("summary omits unavailable indicators", {
  report <- macro_report(year = 1971)
  
  report_summary <- summary(report)
  
  expect_s3_class(report_summary, "summary_normacro_report")
  
  text <- paste(report_summary$text, collapse = " ")
  
  expect_false(grepl("Styringsrenten", text, fixed = TRUE))
  
  expect_false(grepl("rentekurven", text, fixed = TRUE))
})


test_that("summary describes negative GDP growth as a fall", {
  report <- macro_report(year = 2020)
  
  report_summary <- summary(report)
  
  text <- paste(report_summary$text, collapse = " ")
  
  expect_match(text, "BNP Fastlands-Norge falt med", fixed = TRUE)
  
  expect_false(grepl("falt med -", text, fixed = TRUE))
})

test_that("summary describes positive GDP growth as growth", {
  report <- macro_report(year = 2025)
  
  report_summary <- summary(report)
  
  text <- paste(report_summary$text, collapse = " ")
  
  expect_match(text, "BNP Fastlands-Norge vokste med", fixed = TRUE)
})
