
test_that("igangsatte boliger finnes i databasen", {
  expect_true(
    "Igangsatte_boliger" %in% names(normacro)
  )
})

test_that("igangsatte boliger har forventet dekning og verdier", {
  data <- normacro |>
    dplyr::select(
      "Aar",
      "Igangsatte_boliger"
    ) |>
    dplyr::filter(
      !is.na(.data$Igangsatte_boliger)
    )
  
  expect_equal(
    range(data$Aar),
    c(2000L, 2025L)
  )
  
  expect_equal(
    nrow(data),
    26L
  )
  
  expect_false(
    anyNA(data$Igangsatte_boliger)
  )
  
  expect_equal(
    data$Igangsatte_boliger[data$Aar == 2025],
    20184
  )
})

test_that("get_igangsatte_boliger henter live-data", {
  skip_if_not_live_api()
  
  data <- get_igangsatte_boliger(
    refresh = TRUE
  )
  
  expect_s3_class(
    data,
    "data.frame"
  )
  
  expect_true(
    all(
      c("Aar", "Igangsatte_boliger") %in%
        names(data)
    )
  )
  
  expect_equal(
    data$Igangsatte_boliger[data$Aar == 2025],
    20184
  )
})
