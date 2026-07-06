
testthat::test_that(
  "plot_correlation_matrix returns a ggplot object for valid variables", {
    
    p <- plot_correlation_matrix(
      variables = c(
        "BNP_Fastland",
        "Privat_konsum",
        "Industriproduksjon"
      ),
      data = normacro
    )
    
    testthat::expect_s3_class(p, "ggplot")
    
  })

testthat::test_that(
  "plot_correlation_matrix supports year filtering", {
    
    p <- plot_correlation_matrix(
      variables = c(
        "Inflasjon",
        "Styringsrente"
      ),
      data = normacro,
      start_year = 1990,
      end_year = 2020
    )
    
    testthat::expect_s3_class(p, "ggplot")
    
  })

testthat::test_that(
  "plot_correlation_matrix throws an error for unknown variables", {
    
    testthat::expect_error(
      
      plot_correlation_matrix(
        variables = c("Finnes_ikke"),
        data = normacro
      )
      
    )
    
  })
