
testthat::test_that(
  "kostra_change calculates percentage-point change for rates",
  {
    result <- kostra_change(
      variable = "Netto_driftsresultat",
      data = kostra,
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_change"
    )
    
    testthat::expect_true(
      "Endring_prosentpoeng" %in% names(result)
    )
    
    testthat::expect_false(
      "Endring_prosent" %in% names(result)
    )
  }
)

testthat::test_that(
  "kostra_change calculates percentage change for level variables",
  {
    result <- kostra_change(
      variable = "Frie_inntekter_per_innbygger",
      data = kostra,
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_true(
      "Endring_prosent" %in% names(result)
    )
  }
)

testthat::test_that(
  "kostra_change ranks complete observations",
  {
    result <- kostra_change(
      variable = "Netto_driftsresultat",
      data = kostra,
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_equal(
      result$Enhet[result$Rang == 1],
      "5001"
    )
  }
)

testthat::test_that(
  "kostra_change keeps units with missing start values",
  {
    result <- kostra_change(
      variable = "Netto_driftsresultat",
      data = kostra,
      start_year = 2015,
      end_year = 2025
    )
    
    bergen <- result |>
      dplyr::filter(.data$Enhet == "4601")
    
    testthat::expect_true(
      is.na(bergen$Startverdi)
    )
    
    testthat::expect_true(
      is.na(bergen$Rang)
    )
  }
)

testthat::test_that(
  "kostra_change rejects invalid periods",
  {
    testthat::expect_error(
      kostra_change(
        variable = "Netto_driftsresultat",
        data = kostra,
        start_year = 2025,
        end_year = 2020
      )
    )
  }
)
