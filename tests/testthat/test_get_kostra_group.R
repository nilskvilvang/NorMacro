
testthat::test_that(
  "get_kostra_group returns one row for a valid unit",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group(
      unit = "1103",
      date = "2025-01-01"
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
      result$Enhet_navn,
      "Stavanger"
    )
  }
)


testthat::test_that(
  "get_kostra_group returns the expected KOSTRA group",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group(
      unit = "1103",
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      result$KOSTRA_gruppe,
      "EKG12"
    )
    
    testthat::expect_equal(
      result$KOSTRA_gruppe_navn,
      "KOSTRA-gruppe 12"
    )
  }
)


testthat::test_that(
  "get_kostra_group returns Oslo in KOSTRA group 13",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group(
      unit = "0301",
      date = "2025-01-01"
    )
    
    testthat::expect_equal(
      result$KOSTRA_gruppe,
      "EKG13"
    )
  }
)


testthat::test_that(
  "get_kostra_group supports historical dates",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_group(
      unit = "1103",
      date = "2020-01-01"
    )
    
    testthat::expect_equal(
      result$Enhet,
      "1103"
    )
    
    testthat::expect_equal(
      result$KOSTRA_gruppe,
      "EKG12"
    )
  }
)


testthat::test_that(
  "get_kostra_group rejects unknown units",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_group(
        unit = "9999",
        date = "2025-01-01"
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)