
testthat::test_that("Netto IIP can be retrieved from SSB", {
  skip_if_not_live_api()

  x <- get_netto_iip(refresh = TRUE)

  testthat::expect_equal(min(x$Aar), 1998)
  testthat::expect_gte(max(x$Aar), 2025)
  testthat::expect_equal(anyDuplicated(x$Aar), 0)
  testthat::expect_false(anyNA(x$Netto_IIP))

  testthat::expect_equal(
    x$Netto_IIP[x$Aar == 1998],
    104036
  )

  testthat::expect_equal(
    x$Netto_IIP[x$Aar == 2012],
    2792613
  )
})

testthat::test_that("Netto IIP is included in the NorMacro fixture", {
  testthat::expect_true("Netto_IIP" %in% names(normacro))
  testthat::expect_true("Netto_IIP_andel_BNP" %in% names(normacro))

  x <- normacro |>
    dplyr::filter(!is.na(.data$Netto_IIP))

  testthat::expect_equal(min(x$Aar), 1998)
  testthat::expect_gte(max(x$Aar), 2025)
  testthat::expect_equal(anyDuplicated(x$Aar), 0)
  testthat::expect_false(anyNA(x$Netto_IIP))
})

testthat::test_that("Netto IIP share of GDP is calculated correctly", {
  x <- normacro |>
    dplyr::filter(
      !is.na(.data$Netto_IIP),
      !is.na(.data$BNP_lopende)
    )

  testthat::expect_equal(
    x$Netto_IIP_andel_BNP,
    x$Netto_IIP / x$BNP_lopende * 100
  )
})
