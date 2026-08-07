
testthat::test_that(
  "compare_kostra_units returns a comparison table",
  {
    result <- compare_kostra_units(
      variable = "Netto_driftsresultat",
      data = kostra,
      year = 2025
    )
    
    testthat::expect_s3_class(
      result,
      "kostra_unit_comparison"
    )
    
    testthat::expect_true(
      all(
        c(
          "Rang",
          "Enhet",
          "Enhet_navn",
          "Enhetstype",
          "Aar",
          "Verdi"
        ) %in% names(result)
      )
    )
  }
)

testthat::test_that(
  "compare_kostra_units supports selected units",
  {
    result <- compare_kostra_units(
      variable = "Netto_driftsresultat",
      data = kostra,
      units = c(
        "0301",
        "4601"
      ),
      year = 2025
    )
    
    testthat::expect_equal(
      sort(result$Enhet),
      c(
        "0301",
        "4601"
      )
    )
  }
)

testthat::test_that(
  "compare_kostra_units includes percentage-point change for rates",
  {
    result <- compare_kostra_units(
      variable = "Netto_driftsresultat",
      data = kostra,
      year = 2025,
      start_year = 2020
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
  "compare_kostra_units includes percentage change for level variables",
  {
    result <- compare_kostra_units(
      variable = "Frie_inntekter_per_innbygger",
      data = kostra,
      year = 2025,
      start_year = 2020
    )
    
    testthat::expect_true(
      "Endring_prosent" %in% names(result)
    )
  }
)

testthat::test_that(
  "compare_kostra_units rejects unknown units",
  {
    testthat::expect_error(
      compare_kostra_units(
        variable = "Netto_driftsresultat",
        data = kostra,
        units = "9999",
        year = 2025
      ),
      "Fant ikke KOSTRA-enheter"
    )
  }
)

testthat::test_that(
  "compare_kostra_units rejects invalid start year",
  {
    testthat::expect_error(
      compare_kostra_units(
        variable = "Netto_driftsresultat",
        data = kostra,
        year = 2025,
        start_year = 2025
      )
    )
  }
)
