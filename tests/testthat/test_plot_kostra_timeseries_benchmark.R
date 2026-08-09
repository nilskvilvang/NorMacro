
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
      "`data`.*oppgis"
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
      result$data$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      result$data$Antall_enheter,
      rep(11L, 6)
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - 2020-2025 | KOSTRA-gruppe 12"
    )
    
    testthat::expect_equal(
      result$labels$caption,
      "Kilde: SSB KOSTRA, tabell 12134"
    )
  }
)


testthat::test_that(
  "plot_kostra_timeseries_benchmark supports county comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2019,
      end_year = 2025,
      comparison = "county"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      result$data$Aar,
      2019:2025
    )
    
    testthat::expect_equal(
      result$data$Antall_enheter,
      c(
        26L,
        rep(23L, 6)
      )
    )
    
    testthat::expect_equal(
      result$data$Rang,
      c(
        4L,
        9L,
        6L,
        11L,
        14L,
        16L,
        15L
      )
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - 2019-2025 | Fylke: Rogaland"
    )
    
    testthat::expect_equal(
      result$labels$caption,
      "Kilde: SSB KOSTRA, tabell 12134"
    )
  }
)

testthat::test_that(
  "plot_kostra_timeseries_benchmark supports custom comparison",
  {
    skip_if_not_live_api()
    
    p <- plot_kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      comparison = "custom",
      comparison_units = c(
        "1103",
        "1108",
        "1120",
        "1121",
        "1122",
        "1124"
      ),
      comparison_name = "Nabokommuner"
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
    
    testthat::expect_equal(
      p$labels$title,
      "Netto driftsresultat"
    )
    
    testthat::expect_equal(
      p$labels$subtitle,
      "Stavanger - 2020-2025 | Nabokommuner"
    )
    
    testthat::expect_equal(
      p$data$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      p$data$Antall_enheter,
      rep(6L, 6)
    )
    
    testthat::expect_equal(
      p$data$Verdi,
      c(
        4.3,
        8.0,
        6.4,
        3.2,
        -0.1,
        2.9
      )
    )
    
    testthat::expect_equal(
      attr(
        p$data,
        "comparison"
      ),
      "custom"
    )
    
    testthat::expect_equal(
      attr(
        p$data,
        "comparison_group_name"
      ),
      "Nabokommuner"
    )
    
    testthat::expect_equal(
      attr(
        p$data,
        "comparison_units"
      ),
      c(
        "1103",
        "1108",
        "1120",
        "1121",
        "1122",
        "1124"
      )
    )
  }
)

