
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
  "plot_kostra_position_over_time supports KOSTRA group comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
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
      "Stavanger - 2020-2025 - 11 enheter | KOSTRA-gruppe 12"
    )
    
    testthat::expect_equal(
      result$labels$y,
      "Percentil"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time supports county percentile comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
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
      paste0(
        "Stavanger - 2019-2025 - ",
        "23-26 enheter over perioden | Fylke: Rogaland"
      )
    )
    
    testthat::expect_equal(
      result$labels$y,
      "Percentil"
    )
  }
)


testthat::test_that(
  "plot_kostra_position_over_time supports county rank comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2019,
      end_year = 2025,
      metric = "rank",
      comparison = "county"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
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
      result$labels$y,
      "Rang"
    )
    
    rank_scale <- result$scales$get_scales("y")
    
    testthat::expect_equal(
      rank_scale$breaks,
      c(
        1,
        5,
        10,
        15,
        20,
        25
      )
    )
    
    testthat::expect_false(
      26 %in% rank_scale$breaks
    )
  }
)

testthat::test_that(
  "plot_kostra_position_over_time supports custom percentile comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
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
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      result$data$Percentil,
      c(
        80,
        80,
        60,
        40,
        40,
        20
      )
    )
    
    testthat::expect_equal(
      result$data$Antall_enheter,
      rep(6L, 6)
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - 2020-2025 - 6 enheter | Nabokommuner"
    )
    
    testthat::expect_equal(
      result$labels$y,
      "Percentil"
    )
    
    testthat::expect_equal(
      attr(
        result$data,
        "comparison"
      ),
      "custom"
    )
    
    testthat::expect_equal(
      attr(
        result$data,
        "comparison_group_name"
      ),
      "Nabokommuner"
    )
  }
)

testthat::test_that(
  "plot_kostra_position_over_time supports custom rank comparison",
  {
    skip_if_not_live_api()
    
    result <- plot_kostra_position_over_time(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      metric = "rank",
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
      result,
      "ggplot"
    )
    
    testthat::expect_equal(
      result$data$Rang,
      c(
        2L,
        2L,
        3L,
        4L,
        4L,
        5L
      )
    )
    
    testthat::expect_equal(
      result$labels$subtitle,
      "Stavanger - 2020-2025 - 6 enheter | Nabokommuner"
    )
    
    testthat::expect_equal(
      result$labels$y,
      "Rang"
    )
    
    rank_scale <- result$scales$get_scales(
      "y"
    )
    
    testthat::expect_equal(
      rank_scale$breaks,
      1:6
    )
  }
)
