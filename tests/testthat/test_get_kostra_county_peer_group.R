
testthat::test_that(
  "get_kostra_county_peer_group returns all Rogaland municipalities",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county_peer_group(
      unit = "1103",
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      nrow(result),
      23L
    )
    
    testthat::expect_true(
      all(
        result$Fylke == "11"
      )
    )
    
    testthat::expect_true(
      all(
        result$Fylke_navn == "Rogaland"
      )
    )
    
    testthat::expect_true(
      "1103" %in% result$Enhet
    )
  }
)
