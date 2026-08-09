
testthat::test_that(
  "plot_public_sector_macro returns ggplot for index",
  {
    skip_if_not_live_api()
    
    result <- plot_public_sector_macro(
      start_year = 2020,
      end_year = 2025,
      measure = "index",
      base_year = 2020
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      attr(result, "measure"),
      "index"
    )
    
    testthat::expect_equal(
      attr(result, "base_year"),
      2020L
    )
    
    testthat::expect_false(
      attr(result, "include_state")
    )
  }
)

testthat::test_that(
  "plot_public_sector_macro excludes state from index by default",
  {
    skip_if_not_live_api()
    
    result <- plot_public_sector_macro(
      start_year = 2020,
      end_year = 2025,
      measure = "index",
      base_year = 2020
    )
    
    testthat::expect_setequal(
      unique(result$data$Variabel),
      c(
        "BNP_Fastlands",
        "Offentlig_konsum",
        "Kommunalt_konsum"
      )
    )
  }
)

testthat::test_that(
  "plot_public_sector_macro can include state in index",
  {
    skip_if_not_live_api()
    
    result <- plot_public_sector_macro(
      start_year = 2020,
      end_year = 2025,
      measure = "index",
      base_year = 2020,
      include_state = TRUE
    )
    
    testthat::expect_setequal(
      unique(result$data$Variabel),
      c(
        "BNP_Fastlands",
        "Offentlig_konsum",
        "Kommunalt_konsum",
        "Statlig_konsum"
      )
    )
    
    testthat::expect_true(
      attr(result, "include_state")
    )
  }
)

testthat::test_that(
  "plot_public_sector_macro keeps state and municipality in public share",
  {
    skip_if_not_live_api()
    
    result <- plot_public_sector_macro(
      start_year = 2020,
      end_year = 2025,
      measure = "share_public"
    )
    
    testthat::expect_setequal(
      unique(result$data$Variabel),
      c(
        "Kommunalt_konsum",
        "Statlig_konsum"
      )
    )
  }
)

testthat::test_that(
  "plot_public_sector_macro validates include_state",
  {
    testthat::expect_error(
      plot_public_sector_macro(
        include_state = NA
      ),
      "`include_state`"
    )
  }
)

