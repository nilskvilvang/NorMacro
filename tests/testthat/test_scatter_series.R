
testthat::test_that(
  "scatter_series returns a ggplot object for Norwegian data",
  {
    result <- scatter_series(
      x = "BNP_Fastland_vekst",
      y = "Arbeidsledighetsrate_NAV",
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
    international_test <- tibble::tibble(
      Land = rep(
        c("SE", "NO"),
        each = 4
      ),
      Aar = rep(
        2022:2025,
        times = 2
      ),
      Inflasjon = c(
        8.4, 5.9, 2.0, 2.3,
        5.8, 5.5, 3.1, 3.0
      ),
      BNP_vekst = c(
        2.7, -0.2, 1.0, 1.4,
        3.0, 0.5, 2.1, 1.8
      )
    )
    
    result <- scatter_series(
      x = "Inflasjon",
      y = "BNP_vekst",
      data = international_test,
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
    kostra_test <- tibble::tibble(
      Enhet = rep(
        c("0301", "4601"),
        each = 4
      ),
      Enhet_navn = rep(
        c("Oslo - Oslove", "Bergen"),
        each = 4
      ),
      Enhetstype = "kommune",
      Aar = rep(
        2022:2025,
        times = 2
      ),
      Netto_driftsresultat = c(
        5.4, -0.8, -0.9, 3.7,
        4.6, 2.0, -2.4, 1.0
      ),
      Brutto_investeringsutgifter = c(
        20.7, 22.8, 26.8, 24.7,
        19.0, 20.5, 18.0, 12.3
      )
    )
    
    attr(
      kostra_test,
      "dataset_type"
    ) <- "kostra"
    
    attr(
      kostra_test,
      "kostra_table"
    ) <- "12134"
    
    attr(
      kostra_test,
      "kostra_title"
    ) <- "Utvalgte nøkkeltall for kommuneregnskap"
    
    result <- scatter_series(
      x = "Brutto_investeringsutgifter",
      y = "Netto_driftsresultat",
      data = kostra_test,
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
    kostra_test <- tibble::tibble(
      Enhet = rep(
        c("0301", "4601"),
        each = 2
      ),
      Enhet_navn = rep(
        c("Oslo - Oslove", "Bergen"),
        each = 2
      ),
      Enhetstype = "kommune",
      Aar = rep(
        2024:2025,
        times = 2
      ),
      Netto_driftsresultat = c(
        -0.9, 3.7,
        -2.4, 1.0
      ),
      Brutto_investeringsutgifter = c(
        26.8, 24.7,
        18.0, 12.3
      )
    )
    
    attr(
      kostra_test,
      "dataset_type"
    ) <- "kostra"
    
    attr(
      kostra_test,
      "kostra_table"
    ) <- "12134"
    
    attr(
      kostra_test,
      "kostra_title"
    ) <- "Utvalgte nøkkeltall for kommuneregnskap"
    
    testthat::expect_error(
      scatter_series(
        x = "Brutto_investeringsutgifter",
        y = "Netto_driftsresultat",
        data = kostra_test
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
      y = "Arbeidsledighetsrate_NAV",
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