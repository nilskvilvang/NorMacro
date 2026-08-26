
test_that("statsrente has long continuous history", {
  x <- get_statsrente(refresh = TRUE)

  expect_equal(min(x$Aar), 1921L)
  expect_true(max(x$Aar) >= 2025L)
  expect_equal(
    x$Aar,
    seq.int(min(x$Aar), max(x$Aar))
  )
  expect_false(anyNA(x$Statsrente_10aar))
})

test_that("statsrente source transitions are covered", {
  x <- get_statsrente(refresh = TRUE)

  expect_true(all(c(
    1984L,
    1985L,
    2018L,
    2019L
  ) %in% x$Aar))
})

test_that("HMFS statsrente resource is complete", {
  x <- get_statsrente_hmfs()

  expect_equal(nrow(x), 64L)
  expect_equal(x$Aar, 1921:1984)
  expect_false(anyNA(x$Statsrente_10aar))
})
