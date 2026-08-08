
testthat::test_that(
  "get_kostra_county_membership_history reflects municipality reform",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county_membership_history(
      start_year = 2019,
      end_year = 2025
    )
    
    rogaland <- result |>
      dplyr::filter(
        .data$Fylke == "11"
      ) |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
      )
    
    testthat::expect_equal(
      rogaland$Aar,
      2019:2025
    )
    
    testthat::expect_equal(
      rogaland$Antall,
      c(
        26L,
        rep(23L, 6)
      )
    )
  }
)
