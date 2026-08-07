
testthat::test_that(
  "benchmark_kostra returns benchmark information",
  {
    result <- benchmark_kostra(
      variable = "Netto_driftsresultat",
      data = kostra,
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
      data = kostra,
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
      data = kostra,
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
      data = kostra,
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
        data = kostra,
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
        data = kostra,
        unit = "0301",
        year = 2025
      )
    )
  }
)
