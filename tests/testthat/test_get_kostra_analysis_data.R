
testthat::test_that(
  "get_kostra_analysis_data supports table 12134",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_analysis_data(
      table = "12134",
      regions = c(
        "1103",
        "1108"
      ),
      years = 2024:2025,
      variables = "Netto_driftsresultat"
    )
    
    testthat::expect_equal(
      names(result),
      c(
        "Enhet",
        "Enhet_navn",
        "Enhetstype",
        "Aar",
        "Netto_driftsresultat"
      )
    )
    
    testthat::expect_equal(
      nrow(result),
      4L
    )
    
    testthat::expect_equal(
      attr(result, "kostra_table"),
      "12134"
    )
  }
)


testthat::test_that(
  "get_kostra_analysis_data resolves concepts for table 12135",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_analysis_data(
      table = "12135",
      regions = c(
        "1103",
        "1108"
      ),
      years = 2024:2025,
      variables = "Langsiktig_gjeld_uten_pensjonsforpliktelser"
    )
    
    testthat::expect_true(
      "Langsiktig_gjeld_uten_pensjonsforpliktelser" %in%
        names(result)
    )
    
    testthat::expect_equal(
      nrow(result),
      4L
    )
    
    testthat::expect_equal(
      attr(result, "kostra_table"),
      "12135"
    )
  }
)


testthat::test_that(
  "get_kostra_analysis_data supports table 12858",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_analysis_data(
      table = "12858",
      regions = c(
        "1103",
        "1108"
      ),
      years = 2024:2025,
      variables = "Netto_driftsresultat"
    )
    
    testthat::expect_true(
      "Netto_driftsresultat" %in%
        names(result)
    )
    
    testthat::expect_equal(
      nrow(result),
      4L
    )
    
    testthat::expect_equal(
      attr(result, "kostra_table"),
      "12858"
    )
  }
)


testthat::test_that(
  "get_kostra_analysis_data rejects variables not in table",
  {
    testthat::expect_error(
      get_kostra_analysis_data(
        table = "12135",
        regions = "1103",
        years = 2025,
        variables = "Finnes_ikke"
      ),
      "Fant ikke variabelen"
    )
  }
)
