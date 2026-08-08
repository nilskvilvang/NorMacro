
testthat::test_that(
  "prepare_kostra_comparison matches peer analysis for KOSTRA group",
  {
    skip_if_not_live_api()
    
    old <- prepare_kostra_peer_analysis(
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    new <- prepare_kostra_comparison(
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      comparison = "kostra_group"
    )
    
    testthat::expect_identical(
      new$data,
      old$data
    )
    
    testthat::expect_identical(
      new$unit,
      old$unit
    )
    
    testthat::expect_identical(
      new$unit_name,
      old$unit_name
    )
    
    testthat::expect_identical(
      new$group_code,
      old$group_code
    )
    
    testthat::expect_identical(
      new$group_name,
      old$group_name
    )
  }
)


testthat::test_that(
  "prepare_kostra_comparison prepares county comparison",
  {
    skip_if_not_live_api()
    
    result <- prepare_kostra_comparison(
      unit = "1103",
      start_year = 2019,
      end_year = 2025,
      comparison = "county"
    )
    
    testthat::expect_equal(
      result$unit,
      "1103"
    )
    
    testthat::expect_equal(
      result$unit_name,
      "Stavanger"
    )
    
    testthat::expect_equal(
      result$comparison,
      "county"
    )
    
    testthat::expect_equal(
      result$group_code,
      "11"
    )
    
    testthat::expect_equal(
      result$group_name,
      "Rogaland"
    )
    
    counts <- result$data |>
      dplyr::distinct(
        Aar,
        Enhet
      ) |>
      dplyr::count(
        Aar,
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
  }
)


testthat::test_that(
  "prepare_kostra_comparison defaults to KOSTRA group",
  {
    skip_if_not_live_api()
    
    implicit <- prepare_kostra_comparison(
      unit = "1103",
      start_year = 2025,
      end_year = 2025
    )
    
    explicit <- prepare_kostra_comparison(
      unit = "1103",
      start_year = 2025,
      end_year = 2025,
      comparison = "kostra_group"
    )
    
    testthat::expect_identical(
      implicit$data,
      explicit$data
    )
    
    testthat::expect_equal(
      implicit$comparison,
      "kostra_group"
    )
  }
)


testthat::test_that(
  "prepare_kostra_comparison rejects invalid comparison",
  {
    testthat::expect_error(
      prepare_kostra_comparison(
        unit = "1103",
        start_year = 2025,
        end_year = 2025,
        comparison = "invalid"
      ),
      "'arg' should be one of"
    )
  }
)


testthat::test_that(
  "prepare_kostra_comparison rejects reversed years",
  {
    testthat::expect_error(
      prepare_kostra_comparison(
        unit = "1103",
        start_year = 2025,
        end_year = 2020
      ),
      "`start_year` kan ikke være større enn `end_year`"
    )
  }
)
