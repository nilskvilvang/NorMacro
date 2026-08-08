
test_that("get_kostra_keyfigures returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_keyfigures(
    regions = "0301",
    years = 2024
  )
  
  expect_s3_class(result, "data.frame")
  
  expect_true(
    all(
      c(
        "Enhet",
        "Enhet_navn",
        "Enhetstype",
        "Aar"
      ) %in% names(result)
    )
  )
  
  expect_true(
    "Netto_driftsresultat" %in% names(result)
  )
  
})

test_that("get_kostra_financial_keyfigures returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_financial_keyfigures(
    regions = "0301",
    concepts = "AGD23",
    years = 2024
  )
  
  expect_s3_class(result, "data.frame")
  
  expect_true(
    all(
      c(
        "Enhet",
        "Enhet_navn",
        "Enhetstype",
        "Aar",
        "Netto_driftsresultat"
      ) %in% names(result)
    )
  )
  
})

test_that("get_kostra_main_accounts returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_main_accounts(
    regions = "0301",
    concepts = c(
      "AGD13",
      "AGD9",
      "AGD18",
      "AGD23"
    ),
    years = 2024
  )
  
  expect_s3_class(result, "data.frame")
  
  expect_true(
    all(
      c(
        "Enhet",
        "Enhet_navn",
        "Enhetstype",
        "Aar",
        "Brutto_driftsinntekter",
        "Netto_driftsresultat"
      ) %in% names(result)
    )
  )
  
})
