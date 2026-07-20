

testthat::test_that("diagnose returnerer riktig objektstruktur", {
  testthat::expect_s3_class(model_diagnosis, "comparison_series_regression_diagnosis")
  
  testthat::expect_identical(
    names(model_diagnosis),
    c(
      "model_quality",
      "residual_statistics",
      "tests",
      "diagnostic_assessment"
    )
  )
  
  testthat::expect_s3_class(model_diagnosis$model_quality, "tbl_df")
  
  testthat::expect_s3_class(model_diagnosis$residual_statistics, "tbl_df")
  
  testthat::expect_s3_class(model_diagnosis$tests, "tbl_df")
  
  testthat::expect_s3_class(model_diagnosis$diagnostic_assessment, "tbl_df")
})

testthat::test_that("diagnosetabellene har riktige kolonner", {
  testthat::expect_identical(names(model_diagnosis$model_quality), c("Mål", "Verdi"))
  
  testthat::expect_identical(names(model_diagnosis$residual_statistics),
                             c("Statistikk", "Verdi"))
  
  testthat::expect_identical(names(model_diagnosis$tests),
                             c("Test", "Statistikk", "P_verdi"))
  
  testthat::expect_identical(names(model_diagnosis$diagnostic_assessment),
                             c("Type", "Nivå", "Melding"))
})

testthat::test_that("diagnose bruker de etablerte kvalitetsmålene", {
  quality_value <- function(metric) {
    model_diagnosis$model_quality$Verdi[model_diagnosis$model_quality$Mål == metric]
  }
  
  testthat::expect_equal(quality_value("RMSE"), rmse(price_model))
  
  testthat::expect_equal(quality_value("MAE"), mae(price_model))
  
  testthat::expect_equal(quality_value("MAPE"), mape(price_model))
})

testthat::test_that("print endrer ikke diagnoseobjektet", {
  diagnosis_copy <-
    model_diagnosis
  
  output <-
    testthat::capture_output(print(model_diagnosis))
  
  testthat::expect_identical(model_diagnosis, diagnosis_copy)
  
  testthat::expect_true(length(output) > 0L)
})

testthat::test_that("diagnose returnerer tabeller uten manglende kolonnenavn", {
  tables <-
    list(
      model_diagnosis$model_quality,
      model_diagnosis$residual_statistics,
      model_diagnosis$tests,
      model_diagnosis$diagnostic_assessment
    )
  
  purrr::walk(tables, function(table) {
    testthat::expect_false(any(is.na(names(table))))
    
    testthat::expect_false(any(names(table) == ""))
  })
})