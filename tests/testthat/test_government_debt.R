
test_that("government debt includes Norway", {
  debt <- get_government_debt(
    countries = "NO",
    refresh = TRUE
  )

  expect_true(
    nrow(debt) > 0L
  )

  expect_true(
    all(debt$Land == "NO")
  )

  expect_true(
    any(debt$Aar == 2000L)
  )
})

test_that("government debt covers standard countries", {
  debt <- get_government_debt(
    refresh = TRUE
  )

  expect_setequal(
    unique(debt$Land),
    get_standard_countries()
  )
})
