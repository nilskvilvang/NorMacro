
test_that("bytteforhold has expected coverage and reference year", {
  x <- normacro |>
    dplyr::filter(
      !is.na(.data$Bytteforhold)
    )

  expect_equal(
    min(x$Aar),
    1970L
  )

  expect_true(
    max(x$Aar) >= 2025L
  )

  expect_equal(
    x$Aar,
    seq.int(
      min(x$Aar),
      max(x$Aar)
    )
  )

  expect_equal(
    x$Bytteforhold[x$Aar == 2023L],
    100,
    tolerance = 1e-8
  )

  expect_false(
    anyNA(x$Bytteforhold)
  )
})

test_that("bytteforhold matches its documented formula", {
  x <- normacro |>
    dplyr::filter(
      .data$Aar == 2022L
    )

  expected <-
    (x$Eksport_lopende / x$Eksport) /
    (x$Import_lopende / x$Import) * 100

  expect_equal(
    x$Bytteforhold,
    expected,
    tolerance = 1e-10
  )
})