
testthat::test_that(
  "plot_kostra_timeseries_benchmark returns a ggplot object",
  {
    p <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301"
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark supports year filtering",
  {
    p <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "2020-2025"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark uses KOSTRA metadata",
  {
    p <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301"
    )
    
    testthat::expect_equal(
      p$labels$title,
      "Netto driftsresultat"
    )
    
    testthat::expect_equal(
      p$labels$y,
      "prosent"
    )
    
    testthat::expect_match(
      p$labels$caption,
      "SSB KOSTRA"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark supports ascending ranking",
  {
    p <- plot_kostra_timeseries_benchmark(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      descending = FALSE
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark rejects unknown units",
  {
    testthat::expect_error(
      plot_kostra_timeseries_benchmark(
        variable = "Netto_driftsresultat",
        data = kostra_test_data,
        unit = "9999"
      )
    )
  }
)
