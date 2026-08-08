
testthat::test_that(
  "kostra_timeseries_benchmark returns one row per year for selected unit",
  {
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301"
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_timeseries_benchmark"
    )
    
    testthat::expect_true(
      all(
        c(
          "Aar",
          "Verdi",
          "Median",
          "Q1",
          "Q3",
          "Rang",
          "Antall_enheter",
          "Percentil"
        ) %in% names(result)
      )
    )
    
    testthat::expect_true(
      all(result$Enhet == "0301")
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark calculates expected 2025 benchmark",
  {
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301"
    )
    
    result_2025 <- result |>
      dplyr::filter(
        .data$Aar == 2025
      )
    
    testthat::expect_equal(
      result_2025$Rang,
      2
    )
    
    testthat::expect_equal(
      result_2025$Antall_enheter,
      3
    )
    
    testthat::expect_equal(
      result_2025$Percentil,
      50
    )
    
    testthat::expect_equal(
      result_2025$Median,
      3.7
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark uses NA percentile with one unit",
  {
    test_data <- kostra_test_data |>
      dplyr::filter(
        .data$Enhet == "0301",
        .data$Aar == 2025
      )
    
    attr(test_data, "dataset_type") <- "kostra"
    attr(test_data, "kostra_table") <- "12134"
    attr(
      test_data,
      "kostra_title"
    ) <- "Utvalgte nøkkeltall for kommuneregnskap"
    
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = test_data,
      unit = "0301"
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      1L
    )
    
    testthat::expect_true(
      is.na(result$Percentil)
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark supports year filtering",
  {
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      min(result$Aar),
      2020
    )
    
    testthat::expect_equal(
      max(result$Aar),
      2025
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark supports ascending ranking",
  {
    result <- kostra_timeseries_benchmark(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      descending = FALSE
    )
    
    testthat::expect_false(
      attr(result, "descending")
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark rejects unknown units",
  {
    testthat::expect_error(
      kostra_timeseries_benchmark(
        variable = "Netto_driftsresultat",
        data = kostra_test_data,
        unit = "9999"
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)

testthat::test_that(
  "kostra_timeseries_benchmark gives equal rank to tied values",
  {
    test_data <- kostra_test_data |>
      dplyr::filter(
        .data$Aar == 2025
      )
    
    test_data$Netto_driftsresultat <- c(
      6,
      6,
      5
    )
    
    attr(test_data, "dataset_type") <- "kostra"
    attr(test_data, "kostra_table") <- "12134"
    attr(
      test_data,
      "kostra_title"
    ) <- "Utvalgte nøkkeltall for kommuneregnskap"
    
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = test_data,
      unit = "4601",
      descending = TRUE
    )
    
    testthat::expect_equal(
      result$Rang,
      1L
    )
  }
)

testthat::test_that(
  "kostra_timeseries_benchmark keeps data comparison as default",
  {
    default_result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    explicit_result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      start_year = 2020,
      end_year = 2025,
      comparison = "data"
    )
    
    testthat::expect_equal(
      default_result,
      explicit_result
    )
  }
)


testthat::test_that(
  "kostra_timeseries_benchmark requires data for data comparison",
  {
    testthat::expect_error(
      kostra_timeseries_benchmark(
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
  "kostra_timeseries_benchmark supports KOSTRA group comparison",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      comparison = "kostra_group"
    )
    
    testthat::expect_equal(
      result$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      rep(11L, 6)
    )
    
    testthat::expect_equal(
      result$Percentil,
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
      attr(result, "comparison_group"),
      "KOSTRA-gruppe"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_group"),
      "EKG12"
    )
  }
)

