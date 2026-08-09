
testthat::test_that(
  "benchmark_kostra supports non-12134 KOSTRA group comparison",
  {
    skip_if_not_live_api()
    
    result <- benchmark_kostra(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      year = 2025,
      comparison = "kostra_group",
      table = "12135"
    )
    
    testthat::expect_equal(
      result$Enhet,
      "1103"
    )
    
    testthat::expect_equal(
      result$Antall_enheter,
      11L
    )
    
    testthat::expect_equal(
      attr(result, "variable"),
      "Langsiktig_gjeld_uten_pensjonsforpliktelser"
    )
    
    testthat::expect_equal(
      attr(result, "comparison"),
      "kostra_group"
    )
    
    testthat::expect_equal(
      attr(result, "comparison_group_name"),
      "KOSTRA-gruppe 12"
    )
  }
)

testthat::test_that(
  "benchmark_kostra supports non-12134 county and custom comparisons",
  {
    skip_if_not_live_api()
    
    county <- benchmark_kostra(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      year = 2025,
      comparison = "county",
      table = "12135"
    )
    
    custom <- benchmark_kostra(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      unit = "1103",
      year = 2025,
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
      23L
    )
    
    testthat::expect_equal(
      attr(county, "comparison_group_name"),
      "Rogaland"
    )
    
    testthat::expect_equal(
      custom$Antall_enheter,
      3L
    )
    
    testthat::expect_equal(
      attr(custom, "comparison_group_name"),
      "Testgruppe"
    )
  }
)
