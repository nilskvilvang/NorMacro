
testthat::test_that(
  "get_kostra_county_peer_group_data returns historical county data",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county_peer_group_data(
      unit = "1103",
      years = 2019:2025
    )
    
    counts <- result |>
      dplyr::distinct(
        .data$Aar,
        .data$Enhet
      ) |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
      )
    
    testthat::expect_equal(
      counts$Aar,
      2019:2025
    )
    
    testthat::expect_equal(
      counts$Antall,
      c(
        26L,
        rep(23L, 6)
      )
    )
    
    testthat::expect_equal(
      attr(result, "kostra_county_unit"),
      "1103"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_county"),
      "11"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_county_name"),
      "Rogaland"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_county_definition"),
      "historical"
    )
  }
)
