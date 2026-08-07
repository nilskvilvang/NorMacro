
testthat::test_that(
  "plot_kostra_benchmark returns a ggplot object",
  {
    p <- plot_kostra_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
  }
)


testthat::test_that(
  "plot_kostra_benchmark supports lower-is-better ranking",
  {
    p <- plot_kostra_benchmark(
      variable = "Langsiktig_gjeld_uten_pensjonsforpliktelser",
      data = kostra,
      unit = "0301",
      year = 2025,
      descending = FALSE
    )
    
    testthat::expect_s3_class(
      p,
      "ggplot"
    )
  }
)


testthat::test_that(
  "plot_kostra_benchmark uses KOSTRA metadata",
  {
    p <- plot_kostra_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_equal(
      p$labels$title,
      "Netto driftsresultat"
    )
    
    testthat::expect_equal(
      p$labels$x,
      "prosent"
    )
    
    testthat::expect_match(
      p$labels$caption,
      "SSB KOSTRA"
    )
  }
)


testthat::test_that(
  "plot_kostra_benchmark includes selected unit in subtitle",
  {
    p <- plot_kostra_benchmark(
      variable = "Netto_driftsresultat",
      data = kostra,
      unit = "0301",
      year = 2025
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "Oslo"
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "rang 2 av 3"
    )
    
    testthat::expect_match(
      p$labels$subtitle,
      "percentil 50"
    )
  }
)


testthat::test_that(
  "plot_kostra_benchmark rejects non-KOSTRA data",
  {
    testthat::expect_error(
      plot_kostra_benchmark(
        variable = "KPI",
        data = normacro,
        unit = "0301"
      ),
      "KOSTRA"
    )
  }
)


testthat::test_that(
  "plot_kostra_benchmark rejects unknown variables",
  {
    testthat::expect_error(
      plot_kostra_benchmark(
        variable = "Finnes_ikke",
        data = kostra,
        unit = "0301"
      )
    )
  }
)
