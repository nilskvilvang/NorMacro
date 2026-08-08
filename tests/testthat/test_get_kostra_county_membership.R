
testthat::test_that(
  "get_kostra_county_membership returns standardized membership",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county_membership(
      "2025-01-01"
    )
    
    testthat::expect_true(
      all(
        c(
          "Enhet",
          "Enhet_navn",
          "Fylke",
          "Fylke_navn"
        ) %in% names(result)
      )
    )
    
    testthat::expect_equal(
      nrow(result),
      358L
    )
  }
)


testthat::test_that(
  "get_kostra_county_membership identifies major municipalities",
  {
    skip_if_not_live_api()
    
    result <- get_kostra_county_membership(
      "2025-01-01"
    ) |>
      dplyr::filter(
        .data$Enhet %in% c(
          "0301",
          "1103",
          "4601",
          "5001"
        )
      ) |>
      dplyr::arrange(
        .data$Enhet
      )
    
    testthat::expect_equal(
      result$Fylke,
      c(
        "03",
        "11",
        "46",
        "50"
      )
    )
    
    testthat::expect_equal(
      result$Fylke_navn,
      c(
        "Oslo",
        "Rogaland",
        "Vestland",
        "Trøndelag"
      )
    )
  }
)
