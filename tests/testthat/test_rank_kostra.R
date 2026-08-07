


testthat::test_that("rank_kostra returns a KOSTRA ranking", {
  result <- rank_kostra(variable = "Netto_driftsresultat",
                        data = kostra_test_data,
                        year = 2025)
  
  testthat::expect_s3_class(result, "kostra_ranking")
  
  testthat::expect_true(all(
    c("Rang", "Enhet", "Enhet_navn", "Enhetstype", "Aar", "Verdi") %in% names(result)
  ))
  
  testthat::expect_true(all(result$Aar == 2025))
  
})


testthat::test_that("rank_kostra defaults to latest available year", {
  result <- rank_kostra(variable = "Netto_driftsresultat", data = kostra_test_data)
  
  expected_year <- max(kostra_test_data$Aar[!is.na(kostra_test_data$Netto_driftsresultat)])
  
  testthat::expect_equal(attr(result, "year"), expected_year)
})

testthat::test_that("rank_kostra supports ascending ranking", {
  result <- rank_kostra(
    variable = "Netto_driftsresultat",
    data = kostra_test_data,
    year = 2025,
    descending = FALSE
  )
  
  testthat::expect_true(all(diff(result$Verdi) >= 0))
  
})


testthat::test_that("rank_kostra supports top_n", {
  result <- rank_kostra(
    variable = "Netto_driftsresultat",
    data = kostra_test_data,
    year = 2025,
    top_n = 2
  )
  
  testthat::expect_equal(nrow(result), 2)
  
})


testthat::test_that("rank_kostra rejects unknown variables", {
  testthat::expect_error(rank_kostra(variable = "Finnes_ikke", data = kostra_test_data))
  
})

testthat::test_that("rank_kostra gives equal rank to tied values", {
  test_data <- kostra_test_data |>
    dplyr::filter(.data$Aar == 2025)
  
  test_data$Netto_driftsresultat <- c(6, 6, 5)
  
  attr(test_data, "dataset_type") <- "kostra"
  attr(test_data, "kostra_table") <- "12134"
  attr(test_data, "kostra_title") <- "Utvalgte nøkkeltall for kommuneregnskap"
  
  result <- rank_kostra(variable = "Netto_driftsresultat",
                        data = test_data,
                        year = 2025)
  
  testthat::expect_equal(result$Rang, c(1L, 1L, 3L))
})