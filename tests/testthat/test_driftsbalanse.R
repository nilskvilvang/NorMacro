
test_that("get_driftsbalanse returns complete annual Norwegian data", {
  x <- get_driftsbalanse()

  expect_equal(min(x$Aar), 1981L)
  expect_true(max(x$Aar) >= 2025L)
  expect_equal(
    x$Aar,
    seq.int(min(x$Aar), max(x$Aar))
  )
  expect_false(anyNA(x$Driftsbalanse))
  expect_false(anyDuplicated(x$Aar) > 0L)
})


test_that("Norwegian current account share is available", {
  x <- get_normacro()

  y <- x |>
    dplyr::filter(
      !is.na(.data$Driftsbalanse)
    )

  expect_equal(min(y$Aar), 1981L)
  expect_true(max(y$Aar) >= 2025L)
  expect_false(anyNA(y$Driftsbalanse_andel_BNP))
})


test_that("international current account balance has expected coverage", {
  x <- get_current_account_balance()

  coverage <- x |>
    dplyr::group_by(.data$Land) |>
    dplyr::summarise(
      Startaar = min(.data$Aar),
      Sluttaar = max(.data$Aar),
      N = dplyr::n(),
      .groups = "drop"
    )

  expect_equal(
    sort(unique(x$Land)),
    sort(c("DE", "DK", "FI", "FR", "NO", "SE"))
  )

  expect_equal(
    coverage$Startaar[coverage$Land == "DE"],
    1971L
  )

  expect_true(
    all(
      coverage$Startaar[
        coverage$Land %in% c("DK", "FI", "FR", "NO", "SE")
      ] == 1975L
    )
  )

  expect_true(
    all(coverage$Sluttaar >= 2025L)
  )

  expect_false(
    anyNA(x$Driftsbalanse_andel_BNP)
  )
})
