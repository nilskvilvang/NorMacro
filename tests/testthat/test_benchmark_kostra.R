
testthat::test_that(
  "benchmark_kostra returns benchmark information",
  {
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_benchmark"
    )
    
    testthat::expect_true(
      all(
        c(
          "Enhet",
          "Verdi",
          "Rang",
          "Antall_enheter",
          "Percentil",
          "Gjennomsnitt",
          "Median",
          "Avvik_gjennomsnitt",
          "Avvik_median",
          "Q1",
          "Q3",
          "Kvartil"
        ) %in% names(result)
      )
    )
  }
)

testthat::test_that(
  "benchmark_kostra returns correct rank",
  {
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_equal(
      result$Rang,
      2
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      3
    )
  }
)

testthat::test_that(
  "benchmark_kostra calculates deviations from reference values",
  {
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_equal(
      result$Avvik_median,
      result$Verdi - result$Median
    )
    
    testthat::expect_equal(
      result$Avvik_gjennomsnitt,
      result$Verdi - result$Gjennomsnitt
    )
  }
)

testthat::test_that(
  "benchmark_kostra supports ascending ranking",
  {
    result <- benchmark_kostra(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      data = kostra_test_data,
      unit = "0301",
      year = 2025,
      descending = FALSE
    )
    
    testthat::expect_equal(
      result$Rang,
      2
    )
  }
)

testthat::test_that(
  "benchmark_kostra rejects unknown units",
  {
    testthat::expect_error(
      benchmark_kostra(
        variable = "Netto_driftsresultat",
        data = kostra_test_data,
        unit = "9999",
        year = 2025
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)

testthat::test_that(
  "benchmark_kostra rejects unknown variables",
  {
    testthat::expect_error(
      benchmark_kostra(
        variable = "Finnes_ikke",
        data = kostra_test_data,
        unit = "0301",
        year = 2025
      )
    )
  }
)

testthat::test_that(
  "benchmark_kostra keeps data comparison as default",
  {
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      3L
    )
    
    testthat::expect_equal(
      result$Enhet,
      "0301"
    )
    
    testthat::expect_equal(
      result$Verdi,
      3.7
    )
  }
)

testthat::test_that(
  "benchmark_kostra supports KOSTRA group comparison",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      unit = "1103",
      year = 2025,
      comparison = "kostra_group"
    )
    
    testthat::expect_equal(
      result$Enhet,
      "1103"
    )
    
    testthat::expect_equal(
      result$KOSTRA_gruppe,
      "EKG12"
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      11L
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group"),
      "KOSTRA-gruppe"
    )
  }
)

testthat::test_that(
  "benchmark_kostra requires data for data comparison",
  {
    testthat::expect_error(
      benchmark_kostra(
        variable = "Netto_driftsresultat",
        unit = "1103",
        year = 2025
      ),
      "`data` må oppgis"
    )
  }
)

testthat::test_that(
  "benchmark_kostra data comparison is backward compatible",
  {
    default_result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      year = 2025
    )
    
    explicit_result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra_test_data,
      unit = "0301",
      year = 2025,
      comparison = "data"
    )
    
    testthat::expect_equal(
      default_result,
      explicit_result
    )
  }
)

testthat::test_that(
  "benchmark_kostra supports county comparison",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      unit = "1103",
      year = 2025,
      comparison = "county"
    )
    
    testthat::expect_equal(
      result$Enhet,
      "1103"
    )
    
    testthat::expect_equal(
      result$Fylke,
      "11"
    )
    
    testthat::expect_equal(
      result$Fylke_navn,
      "Rogaland"
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      23L
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

