
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
      "`data`.*oppgis"
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

testthat::test_that(
  "kostra_timeseries_benchmark supports county comparison",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2019,
      end_year = 2025,
      comparison = "county"
    )
    
    testthat::expect_equal(
      result$Aar,
      2019:2025
    )
    
    testthat::expect_equal(
      result$Fylke,
      rep("11", 7)
    )
    
    testthat::expect_equal(
      result$Fylke_navn,
      rep("Rogaland", 7)
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      c(
        26L,
        rep(23L, 6)
      )
    )
    
    testthat::expect_equal(
      result$Rang,
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
      attr(result, "comparison"),
      "county"
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group"),
      "Fylke"
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group_code"),
      "11"
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group_name"),
      "Rogaland"
    )
  }
)

testthat::test_that(
  "kostra_timeseries_benchmark supports custom comparison",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark(
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
    
    testthat::expect_equal(
      result$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      rep(6L, 6)
    )
    
    testthat::expect_equal(
      result$Rang,
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
      result$Percentil,
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
      attr(result, "comparison"),
      "custom"
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group"),
      "Egendefinert gruppe"
    )
    
    testthat::expect_null(
      attr(result, "comparison_group_code")
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group_name"),
      "Nabokommuner"
    )
    
    testthat::expect_equal(
      attr(result, "comparison_units"),
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

testthat::test_that(
  "kostra_timeseries_benchmark custom comparison matches explicit data",
  {
    skip_if_not_live_api()
    
    custom_info <- prepare_kostra_comparison(
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
    
    custom_result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      unit = "1103",
      start_year = 2020,
      end_year = 2025,
      comparison = "custom",
      comparison_units = custom_info$comparison_units,
      comparison_name = "Nabokommuner"
    )
    
    data_result <- kostra_timeseries_benchmark(
      variable = "Netto_driftsresultat",
      data = custom_info$data,
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      custom_result |>
        dplyr::select(
          Aar,
          Verdi,
          Rang,
          Antall_enheter,
          Percentil,
          Gjennomsnitt,
          Median,
          Q1,
          Q3
        ),
      data_result |>
        dplyr::select(
          Aar,
          Verdi,
          Rang,
          Antall_enheter,
          Percentil,
          Gjennomsnitt,
          Median,
          Q1,
          Q3
        )
    )
  }
)

testthat::test_that(
  "kostra_timeseries_benchmark supports non-12134 KOSTRA group comparison",
  {
    skip_if_not_live_api()
    
    result <- kostra_timeseries_benchmark(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      start_year = 2024,
      end_year = 2025,
      comparison = "kostra_group",
      table = "12135"
    )
    
    testthat::expect_equal(
      result$Aar,
      2024:2025
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      c(11L, 11L)
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group_name"),
      "KOSTRA-gruppe 12"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_table"),
      "12135"
    )
  }
)

testthat::test_that(
  "kostra_timeseries_benchmark supports non-12134 county and custom comparisons",
  {
    skip_if_not_live_api()
    
    county <- kostra_timeseries_benchmark(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      start_year = 2024,
      end_year = 2025,
      comparison = "county",
      table = "12135"
    )
    
    custom <- kostra_timeseries_benchmark(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      start_year = 2024,
      end_year = 2025,
      comparison = "custom",
      comparison_units = c(
        "1103",
        "1108",
        "1120"
      ),
      comparison_name = "Testgruppe",
      table = "12135"
    )
    
    testthat::expect_equal(
      county$Antall_enheter,
      c(23L, 23L)
    )
    
    testthat::expect_equal(
      custom$Antall_enheter,
      c(3L, 3L)
    )
    
    testthat::expect_equal(
      attr(county, "comparison_group_name"),
      "Rogaland"
    )
    
    testthat::expect_equal(
      attr(custom, "comparison_group_name"),
      "Testgruppe"
    )
  }
)


