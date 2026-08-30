
testthat::test_that("Norwegian investment series are present in fixture", {
  expected <- c(
    "Investeringer",
    "Investeringer_lopende",
    "Investeringer_vekst",
    "Investeringer_andel_BNP"
  )

  testthat::expect_true(
    all(expected %in% names(normacro))
  )
})


testthat::test_that("Norwegian investment series have expected values", {
  x <- normacro |>
    dplyr::filter(
      .data$Aar >= 1970
    ) |>
    dplyr::select(
      "Aar",
      "Investeringer",
      "Investeringer_lopende",
      "Investeringer_vekst",
      "Investeringer_andel_BNP"
    )

  testthat::expect_true(
    nrow(x) >= 50
  )

  testthat::expect_false(
    anyNA(x$Investeringer)
  )

  testthat::expect_false(
    anyNA(x$Investeringer_lopende)
  )

  testthat::expect_equal(
    sum(is.na(x$Investeringer_vekst)),
    1
  )

  testthat::expect_equal(
    x$Aar[which(is.na(x$Investeringer_vekst))],
    1970
  )
})


testthat::test_that("Norwegian investment GDP share is calculated correctly", {
  x <- normacro |>
    dplyr::filter(
      !is.na(.data$Investeringer_lopende),
      !is.na(.data$BNP_lopende)
    )

  testthat::expect_equal(
    x$Investeringer_andel_BNP,
    x$Investeringer_lopende / x$BNP_lopende * 100
  )
})


testthat::test_that("Norwegian investment getter works with live SSB data", {
  skip_if_not_live_api()

  x <- get_investeringer(
    refresh = TRUE
  )

  testthat::expect_equal(
    names(x),
    c(
      "Aar",
      "Investeringer",
      "Investeringer_lopende",
      "Investeringer_vekst"
    )
  )

  testthat::expect_true(
    min(x$Aar) <= 1970
  )

  testthat::expect_true(
    max(x$Aar) >= 2025
  )

  testthat::expect_equal(
    anyDuplicated(x$Aar),
    0
  )

  testthat::expect_false(
    anyNA(x$Investeringer)
  )

  testthat::expect_false(
    anyNA(x$Investeringer_lopende)
  )
})
