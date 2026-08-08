
testthat::test_that(
  "benchmark_kostra_peer_group returns peer group benchmark",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      year = 2025
    )
    
    testthat::expect_equal(
      nrow(result),
      1L
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
      result$KOSTRA_gruppe_navn,
      "KOSTRA-gruppe 12"
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      11L
    )
  }
)


testthat::test_that(
  "benchmark_kostra_peer_group returns benchmark statistics",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      year = 2025
    )
    
    testthat::expect_true(
      all(
        c(
          "Rang",
          "Percentil",
          "Gjennomsnitt",
          "Median",
          "Q1",
          "Q3",
          "Kvartil"
        ) %in% names(result)
      )
    )
  }
)


testthat::test_that(
  "benchmark_kostra_peer_group stores comparison metadata",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra_peer_group(
      variable = "Netto_driftsresultat",
      unit = "1103",
      year = 2025
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group"),
      "KOSTRA-gruppe"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_group"),
      "EKG12"
    )
    
    testthat::expect_equal(
      attr(result, "kostra_group_name"),
      "KOSTRA-gruppe 12"
    )
  }
)


testthat::test_that(
  "benchmark_kostra_peer_group supports ascending ranking",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra_peer_group(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      year = 2025,
      descending = FALSE
    )
    
    testthat::expect_equal(
      result$Enhet,
      "1103"
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      11L
    )
  }
)


testthat::test_that(
  "benchmark_kostra_peer_group rejects unknown units",
  {
    skip_if_not_live_api()
    
    testthat::expect_error(
      benchmark_kostra_peer_group(
        variable = "Netto_driftsresultat",
        unit = "9999",
        year = 2025
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)