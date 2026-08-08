
testthat::test_that(
  "get_kostra_group_membership returns KOSTRA group membership",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership(
      date = "2025-01-01"
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_group_membership"
    )
    
    testthat::expect_true(
      all(
        c(
          "Enhet",
          "Enhet_navn",
          "KOSTRA_gruppe",
          "KOSTRA_gruppe_navn"
        ) %in% names(result)
      )
    )
    
    testthat::expect_gt(
      nrow(result),
      0
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership returns known 2025 memberships",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership(
      date = "2025-01-01"
    )
    
    selected <- result |>
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
      selected$Enhet,
      c(
        "0301",
        "1103",
        "4601",
        "5001"
      )
    )
    
    testthat::expect_equal(
      selected$KOSTRA_gruppe,
      c(
        "EKG13",
        "EKG12",
        "EKG12",
        "EKG12"
      )
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership returns cleaned unit names",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership(
      date = "2025-01-01"
    )
    
    oslo <- result |>
      dplyr::filter(
        .data$Enhet == "0301"
      )
    
    trondheim <- result |>
      dplyr::filter(
        .data$Enhet == "5001"
      )
    
    testthat::expect_equal(
      oslo$Enhet_navn,
      "Oslo"
    )
    
    testthat::expect_equal(
      trondheim$Enhet_navn,
      "Trondheim"
    )
  }
)


testthat::test_that(
  "get_kostra_group_membership stores classification attributes",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership(
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      attr(result, "date"),
      as.Date("2025-01-01")
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
  "get_kostra_group_membership rejects invalid dates",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_group_membership(
        date = c(
          "2025-01-01",
          "2025-02-01"
        )
      ),
      "`date`"
    )
  }
)

testthat::test_that(
  "get_kostra_group_membership returns expected number of 2025 mappings",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group_membership(
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      nrow(result),
      357L
    )
  }
)