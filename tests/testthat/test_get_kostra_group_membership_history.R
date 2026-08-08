
testthat::test_that(
  "get_kostra_group_membership_history returns one row per unit and year",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership_history(
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_group_membership_history"
    )
    
    testthat::expect_true(
      all(
        c(
          "Enhet",
          "Enhet_navn",
          "Aar",
          "KOSTRA_gruppe",
          "KOSTRA_gruppe_navn"
        ) %in% names(result)
      )
    )
    
    testthat::expect_equal(
      min(result$Aar),
      2020
    )
    
    testthat::expect_equal(
      max(result$Aar),
      2025
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership_history returns expected municipality counts",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership_history(
      start_year = 2020,
      end_year = 2025
    )
    
    counts <- result |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
      )
    
    testthat::expect_equal(
      counts$Antall,
      c(
        356L,
        356L,
        356L,
        356L,
        357L,
        357L
      )
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership_history keeps Stavanger in group 12",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership_history(
      start_year = 2020,
      end_year = 2025
    ) |>
      dplyr::filter(
        .data$Enhet == "1103"
      )
    
    testthat::expect_equal(
      nrow(result),
      6L
    )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe == "EKG12"
      )
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership_history keeps Oslo in group 13",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership_history(
      start_year = 2020,
      end_year = 2025
    ) |>
      dplyr::filter(
        .data$Enhet == "0301"
      )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe == "EKG13"
      )
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership_history stores year attributes",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership_history(
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      attr(result, "start_year"),
      2020L
    )
    
    testthat::expect_equal(
      attr(result, "end_year"),
      2025L
    )
    
    testthat::expect_equal(
      attr(result, "source_classification"),
      112L
    )
    
    testthat::expect_equal(
      attr(result, "target_classification"),
      131L
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership_history rejects reversed year ranges",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_group_membership_history(
        start_year = 2025,
        end_year = 2020
      ),
      "`start_year` kan ikke være større enn `end_year`"
    )
  }
)