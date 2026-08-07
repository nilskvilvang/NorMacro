
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