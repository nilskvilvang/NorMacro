
testthat::test_that(
  "get_kostra_county_peer_group_history follows historical municipality codes",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county_peer_group_history(
      unit = "4601",
      start_year = 2019,
      end_year = 2025
    )
    
    testthat::expect_equal(
      sort(
        unique(result$Aar)
      ),
      2020:2025
    )
    
    testthat::expect_true(
      all(
        result$Fylke == "46"
      )
    )
    
    testthat::expect_true(
      all(
        result$Fylke_navn == "Vestland"
      )
    )
  }
)
