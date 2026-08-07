
testthat::test_that("rank_kostra returns a KOSTRA ranking", {
  
  result <- rank_kostra(
    variable = "Netto_driftsresultat",
    data = kostra,
    year = 2025
  )
  
  testthat::expect_s3_class(
    result,
    "kostra_ranking"
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
  
  testthat::expect_true(
    all(result$Aar == 2025)
  )
  
})


testthat::test_that("rank_kostra defaults to latest available year", {
  
  result <- rank_kostra(
    variable = "Netto_driftsresultat",
    data = kostra
  )
  
  testthat::expect_equal(
    attr(result, "year"),
    max(
      kostra$Aar[
        !is.na(kostra$Netto_driftsresultat)
      ]
    )
  )
  
})


testthat::test_that("rank_kostra supports ascending ranking", {
  
  result <- rank_kostra(
    variable = "Netto_driftsresultat",
    data = kostra,
    year = 2025,
    descending = FALSE
  )
  
  testthat::expect_true(
    all(diff(result$Verdi) >= 0)
  )
  
})


testthat::test_that("rank_kostra supports top_n", {
  
  result <- rank_kostra(
    variable = "Netto_driftsresultat",
    data = kostra,
    year = 2025,
    top_n = 2
  )
  
  testthat::expect_equal(
    nrow(result),
    2
  )
  
})


testthat::test_that("rank_kostra rejects unknown variables", {
  
  testthat::expect_error(
    rank_kostra(
      variable = "Finnes_ikke",
      data = kostra
    )
  )
  
})
