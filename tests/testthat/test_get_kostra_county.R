
testthat::test_that(
  "get_kostra_county returns county for a valid municipality",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county(
      unit = "1103",
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      nrow(result),
      1L
    )
    
    testthat::expect_equal(
      result$Enhet_navn,
      "Stavanger"
    )
    
    testthat::expect_equal(
      result$Fylke,
      "11"
    )
    
    testthat::expect_equal(
      result$Fylke_navn,
      "Rogaland"
    )
  }
)


testthat::test_that(
  "get_kostra_county rejects unknown units",
  {
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_county(
        unit = "9999",
        date = "2025-01-01"
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)
