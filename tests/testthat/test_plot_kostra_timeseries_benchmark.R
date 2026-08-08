
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

testthat::test_that(
  "plot_kostra_timeseries_benchmark keeps data comparison as default",
  {
    default_plot <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    explicit_plot <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025,
      comparison = "data"
    )
    
    testthat::expect_s3_class(
      default_plot,
      "ggplot"
    )
    
    testthat::expect_equal(
      default_plot$data,
      explicit_plot$data
    )
    
    testthat::expect_equal(
      default_plot$labels,
      explicit_plot$labels
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark requires data for data comparison",
  {
    testthat::expect_error(
      plot_kostra_timeseries_benchmark(
        variable = "Netto_driftsresultat",
        unit = "1103",
        start_year = 2020,
        end_year = 2025
      ),
      "`data` må oppgis"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark supports KOSTRA group comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      comparison = "kostra_group"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      result$labels$title,
      "Netto driftsresultat"
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - KOSTRA-gruppe 12 - 2020-2025"
    )
    
    testthat::expect_equal(
      result$labels$caption,
      "Kilde: SSB KOSTRA, tabell 12134"
    )
  }
)
