
testthat::test_that(
  "kostra_timeseries_benchmark_peer_group returns historical peer benchmark",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_timeseries_benchmark_peer_group"
    )
    
    testthat::expect_equal(
      result$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      rep(11L, 6)
    )
    
    testthat::expect_true(
      all(
        c(
          "Verdi",
          "Median",
          "Q1",
          "Q3",
          "Rang",
          "Percentil"
        ) %in% names(result)
      )
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark_peer_group stores group metadata",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group"),
      "KOSTRA-gruppe"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_group"),
      "EKG12"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_group_name"),
      "KOSTRA-gruppe 12"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_peer_unit"),
      "1103"
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark_peer_group supports ascending ranking",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark_peer_group(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      descending = FALSE
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      rep(11L, 6)
    )
    
    testthat::expect_true(
      all(!is.na(result$Rang))
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark_peer_group rejects reversed years",
  {
    testthat::expect_error(
      kostra_timeseries_benchmark_peer_group(
        variable = "Netto_driftsresultat",
        unit = "1103",
        start_year = 2025,
        end_year = 2020
      ),
      "`start_year`.*`end_year`"
    )
  }
)
