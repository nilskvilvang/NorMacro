
test_that("get_kostra_keyfigures returns standardized data", {
  
  result <- get_kostra_keyfigures(
    regions = "0301",
    years = 2024
  )
  
  expect_s3_class(result, "data.frame")
  
  expect_named(
    result,
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype",
      "Aar",
      "Netto_driftsresultat",
      "Merforbruk_driftsregnskap",
      "Arbeidskapital_uten_premieavvik",
      "Netto_renteeksponering",
      "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      "Frie_inntekter_per_innbygger",
      "Fri_egenkapital_drift",
      "Brutto_investeringsutgifter",
      "Egenfinansiering_investeringer"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
  
})

test_that("get_kostra_financial_keyfigures returns standardized data", {
  
  result <- get_kostra_financial_keyfigures(
    regions = "0301",
    concepts = "AGD23",
    years = 2024
  )
  
  expect_s3_class(result, "data.frame")
  
  expect_named(
    result,
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype",
      "Aar",
      "Netto_driftsresultat"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
  
})

test_that("get_kostra_main_accounts returns standardized data", {
  
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
  
  expect_named(
    result,
    c(
      "Enhet",
      "Enhet_navn",
      "Enhetstype",
      "Aar",
      "Brutto_driftsinntekter",
      "Brutto_driftsutgifter",
      "Brutto_driftsresultat",
      "Netto_driftsresultat"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
  
})
