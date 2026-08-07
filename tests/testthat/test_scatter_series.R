
testthat::test_that(
  "scatter_series returns a ggplot object for Norwegian data",
  {
    result <- scatter_series(
      x = "BNP_Fastland_vekst",
      y = "Arbledighetsrate_NAV",
      data = normacro
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
  }
)

testthat::test_that(
  "scatter_series supports international data for one country",
  {
    result <- scatter_series(
      x = "Inflasjon",
      y = "BNP_vekst",
      data = international,
      country = "SE"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
  }
)

testthat::test_that(
  "scatter_series supports one KOSTRA unit",
  {
    kostra <- get_kostra_keyfigures(
      regions = c(
        "0301",
        "4601"
      ),
      years = 2015:2025
    )
    
    result <- scatter_series(
      x = "Brutto_investeringsutgifter",
      y = "Netto_driftsresultat",
      data = kostra,
      unit = "0301"
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
  }
)

testthat::test_that(
  "scatter_series requires unit for multiple KOSTRA units",
  {
    kostra <- get_kostra_keyfigures(
      regions = c(
        "0301",
        "4601"
      ),
      years = 2015:2025
    )
    
    testthat::expect_error(
      scatter_series(
        x = "Brutto_investeringsutgifter",
        y = "Netto_driftsresultat",
        data = kostra
      ),
      "flere KOSTRA-enheter"
    )
  }
)

testthat::test_that(
  "scatter_series supports year labels",
  {
    result <- scatter_series(
      x = "BNP_Fastland_vekst",
      y = "Arbledighetsrate_NAV",
      data = normacro,
      label_years = TRUE
    )
    
    testthat::expect_s3_class(
      result,
      "ggplot"
    )
  }
)

testthat::test_that(
  "scatter_series throws an error for unknown variables",
  {
    testthat::expect_error(
      scatter_series(
        x = "Finnes_ikke",
        y = "Inflasjon",
        data = normacro
      )
    )
  }
)