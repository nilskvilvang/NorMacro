
testthat::test_that(
  "plot_kostra_position_over_time_peer_group returns a ggplot for percentile",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_position_over_time_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
    
    testthat::expect_equal(
      p$labels$y,
      "Percentil"
    )
    
    testthat::expect_match(
      p$labels$title,
      "percentil over tid"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time_peer_group supports rank",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_position_over_time_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      metric = "rank"
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
    
    testthat::expect_equal(
      p$labels$y,
      "Rang"
    )
    
    testthat::expect_match(
      p$labels$title,
      "rang over tid"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time_peer_group uses municipality and group in subtitle",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_position_over_time_peer_group(
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
  "plot_kostra_position_over_time_peer_group stores comparison metadata",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_position_over_time_peer_group(
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
      attr(p, "kostra_peer_unit"),
      "1103"
    )
    
    testthat::expect_equal(
      attr(p, "kostra_group"),
      "EKG12"
    )
    
    testthat::expect_equal(
      attr(p, "kostra_group_name"),
      "KOSTRA-gruppe 12"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time_peer_group defaults to percentile",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_position_over_time_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      p$labels$y,
      "Percentil"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time_peer_group rejects invalid metric",
  {
    testthat::expect_error(
      plot_kostra_position_over_time_peer_group(
        variable = "Netto_driftsresultat",
        unit = "1103",
        start_year = 2020,
        end_year = 2025,
        metric = "foo"
      ),
      "'arg' should be one of"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time_peer_group rejects reversed years",
  {
    testthat::expect_error(
      plot_kostra_position_over_time_peer_group(
        variable = "Netto_driftsresultat",
        unit = "1103",
        start_year = 2025,
        end_year = 2020
      ),
      "`start_year`.*`end_year`"
    )
  }
)
