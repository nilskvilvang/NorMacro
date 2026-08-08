
testthat::test_that(
  "get_kostra_peer_group returns all peers for a valid unit",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group(
      unit = "1103",
      date = "2025-01-01"
    )
    
    testthat::expect_gt(
      nrow(result),
      1L
    )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe == "EKG12"
      )
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group includes the selected unit",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group(
      unit = "1103",
      date = "2025-01-01"
    )
    
    testthat::expect_true(
      "1103" %in% result$Enhet
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group returns expected 2025 group 12 size",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group(
      unit = "1103",
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      nrow(result),
      11L
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group returns expected 2025 group 12 members",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group(
      unit = "1103",
      date = "2025-01-01"
    )
    
    expected_units <- c(
      "1103",
      "1108",
      "3107",
      "3201",
      "3203",
      "3205",
      "3301",
      "4204",
      "4601",
      "5001",
      "5501"
    )
    
    testthat::expect_equal(
      sort(result$Enhet),
      sort(expected_units)
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group returns Oslo alone in group 13",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group(
      unit = "0301",
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      nrow(result),
      1L
    )
    
    testthat::expect_equal(
      result$Enhet,
      "0301"
    )
    
    testthat::expect_equal(
      result$KOSTRA_gruppe,
      "EKG13"
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group supports historical dates",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group(
      unit = "1103",
      date = "2020-01-01"
    )
    
    testthat::expect_true(
      "1103" %in% result$Enhet
    )
    
    testthat::expect_true(
      all(result$KOSTRA_gruppe == "EKG12")
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group rejects unknown units",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_peer_group(
        unit = "9999",
        date = "2025-01-01"
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)