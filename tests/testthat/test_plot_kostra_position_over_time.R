
testthat::test_that(
  "plot_kostra_position_over_time returns a ggplot for percentile",
  {
    p <- plot_kostra_position_over_time(
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
  "plot_kostra_position_over_time supports rank",
  {
    p <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      metric = "rank"
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
    
    testthat::expect_match(
      p$labels$title,
      "rang over tid"
    )
    
    testthat::expect_equal(
      p$labels$y,
      "Rang"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time uses percentile by default",
  {
    p <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301"
    )
    
    testthat::expect_match(
      p$labels$title,
      "percentil over tid"
    )
    
    testthat::expect_equal(
      p$labels$y,
      "Percentil"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time supports year filtering",
  {
    p <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "2020-2025"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time reports comparison group size",
  {
    p <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "enheter"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time supports ascending ranking",
  {
    p <- plot_kostra_position_over_time(
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
  "plot_kostra_position_over_time rejects unknown units",
  {
    testthat::expect_error(
      plot_kostra_position_over_time(
        variable = "Netto_driftsresultat",
        data = kostra_test_data,
        unit = "9999"
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time rejects invalid metric",
  {
    testthat::expect_error(
      plot_kostra_position_over_time(
        variable = "Netto_driftsresultat",
        data = kostra_test_data,
        unit = "0301",
        metric = "invalid"
      )
    )
  }
)

testthat::test_that(
  "plot_kostra_position_over_time keeps data comparison as default",
  {
    default_plot <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    explicit_plot <- plot_kostra_position_over_time(
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
  "plot_kostra_position_over_time requires data for data comparison",
  {
    testthat::expect_error(
      plot_kostra_position_over_time(
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
  "plot_kostra_position_over_time supports KOSTRA group percentile comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      metric = "percentile",
      comparison = "kostra_group"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      result$data$Percentil,
      c(
        80,
        100,
        100,
        80,
        40,
        50
      )
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - KOSTRA-gruppe 12 - 2020-2025"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time supports KOSTRA group rank comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      metric = "rank",
      comparison = "kostra_group"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      result$data$Rang,
      c(
        3L,
        1L,
        1L,
        3L,
        7L,
        6L
      )
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - KOSTRA-gruppe 12 - 2020-2025"
    )
  }
)
