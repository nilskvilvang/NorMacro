
test_that("compare_countries returns a ggplot object", {
  p <- compare_countries(
    "BNP_vekst",
    countries = c("NO", "SE"),
    data = normacro_international_example
  )
  
  expect_s3_class(p, "ggplot")
})


test_that("compare_countries supports normalization", {
  p <- compare_countries(
    "BNP_faste_priser",
    countries = c("NO", "SE"),
    data = normacro_international_example,
    start_year = 2000,
    normalize = TRUE
  )
  
  expect_s3_class(p, "ggplot")
})


test_that("compare_countries rejects unknown countries", {
  expect_error(
    compare_countries(
      "BNP_vekst",
      countries = "XX",
      data = normacro_international_example
    ),
    "Fant ikke land"
  )
})


test_that("compare_countries rejects unknown variables", {
  expect_error(
    compare_countries(
      "Finnes_ikke",
      countries = c("NO", "SE"),
      data = normacro_international_example
    ),
    "Fant ikke variabelen"
  )
})


test_that("compare_countries preserves requested country order", {
  p <- compare_countries(
    "BNP_vekst",
    countries = c("NO", "SE", "DK", "DE"),
    data = normacro_international_example
  )
  
  plot_data <- p$data
  
  expect_identical(
    levels(plot_data$Land_navn),
    c(
      "Norge",
      "Sverige",
      "Danmark",
      "Tyskland"
    )
  )
})


test_that("compare_countries uses standard countries when countries is NULL", {
  p <- compare_countries(
    "BNP_vekst",
    data = normacro_international_example
  )
  
  expect_s3_class(p, "ggplot")
  
  expect_identical(
    levels(p$data$Land_navn),
    c(
      "Norge",
      "Sverige",
      "Danmark",
      "Finland",
      "Tyskland",
      "Frankrike"
    )
  )
})
