
test_that("get_pengemarkedsrente returns a complete annual series", {
  x <- get_pengemarkedsrente()

  expect_s3_class(x, "data.frame")

  expect_true(
    all(
      c(
        "Aar",
        "Pengemarkedsrente_3mnd"
      ) %in% names(x)
    )
  )

  expect_equal(
    min(x$Aar),
    1979L
  )

  expect_true(
    max(x$Aar) >= 2025L
  )

  expect_equal(
    x$Aar,
    seq(
      min(x$Aar),
      max(x$Aar)
    )
  )

  expect_false(
    anyNA(x$Pengemarkedsrente_3mnd)
  )

  expect_false(
    anyDuplicated(x$Aar) > 0L
  )
})

test_that("get_pengemarkedsrente contains both source periods", {
  x <- get_pengemarkedsrente()

  expect_true(
    all(
      c(
        1979L,
        2012L,
        2013L,
        2025L
      ) %in% x$Aar
    )
  )

  expect_true(
    all(
      is.finite(x$Pengemarkedsrente_3mnd)
    )
  )
})
