
testthat::test_that(
  "plot_kostra_timeseries_benchmark_peer_group returns a ggplot",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_timeseries_benchmark_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark_peer_group uses municipality name in subtitle",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_timeseries_benchmark_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "Stavanger"
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "KOSTRA-gruppe 12"
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "2020-2025"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark_peer_group stores group metadata",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_timeseries_benchmark_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      attr(p, "comparison_group"),
      "KOSTRA-gruppe"
    )
    
    testthat::expect_equal(
      attr(p, "kostra_group"),
      "EKG12"
    )
  }
)
