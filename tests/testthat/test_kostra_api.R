
test_that("get_kostra_keyfigures returns standardized data", {
  
  skip_if_not_live_api()
  
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
  
  skip_if_not_live_api()
  
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

test_that("get_kostra_debt_keyfigures returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_debt_keyfigures(
    regions = "0301",
    concepts = c(
      "AGD21",
      "KG32",
      "KG39"
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
      "Avdrag_netto",
      "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      "Renteeksponert_gjeld"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
})

test_that("get_kostra_per_capita_keyfigures returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_per_capita_keyfigures(
    regions = "0301",
    concepts = c(
      "AGD13",
      "AGD23",
      "AGI1",
      "KG31"
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
      "Brutto_driftsinntekter_per_innbygger",
      "Netto_driftsresultat_per_innbygger",
      "Brutto_investeringsutgifter_per_innbygger",
      "Netto_laanegjeld_per_innbygger"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
})

test_that("get_kostra_operating_financing returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_operating_financing(
    regions = "0301",
    concepts = c(
      "AG10",
      "A800",
      "AG12",
      "AG44"
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
      "Eiendomsskatt_totalt",
      "Rammetilskudd",
      "Skatt_inntekt_og_formue",
      "Naturressursskatt"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
})

test_that("get_kostra_investment_financing returns standardized data", {
  
  skip_if_not_live_api()
  
  result <- get_kostra_investment_financing(
    regions = "0301",
    concepts = c(
      "AGI29",
      "970",
      "A670",
      "AGI7"
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
      "Bruk_av_laan_netto",
      "Overfoering_fra_drift",
      "Salg_av_fast_eiendom",
      "Aarets_udekket_investeringsregnskap"
    )
  )
  
  expect_equal(
    nrow(result),
    1
  )
})