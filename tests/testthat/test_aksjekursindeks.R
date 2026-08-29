
test_that("historisk aksjekursserie har forventet innhold", {

  path <- system.file(
    "extdata",
    "aksjekurs_hmfs.csv",
    package = "NorMacro"
  )

  hmfs <- readr::read_delim(
    path,
    delim = ";",
    show_col_types = FALSE
  )

  expect_equal(min(hmfs$Aar), 1914)
  expect_equal(max(hmfs$Aar), 2000)
  expect_equal(nrow(hmfs), 87L)

  expect_false(anyNA(hmfs$Aksjekursindeks))
  expect_true(all(hmfs$Aksjekursindeks > 0))
})


test_that("get_aksjekursindeks returnerer forventet serie", {

  skip_if_not_live_api()

  aksje <- get_aksjekursindeks(refresh = TRUE)

  expect_s3_class(aksje, "data.frame")

  expect_named(
    aksje,
    c(
      "Aar",
      "Aksjekursindeks",
      "Aksjekursindeks_vekst"
    )
  )

  expect_equal(min(aksje$Aar), 1914L)
  expect_true(max(aksje$Aar) >= 2025L)

  expect_false(anyNA(aksje$Aksjekursindeks))
  expect_equal(
    sum(is.na(aksje$Aksjekursindeks_vekst)),
    1L
  )

  expect_equal(
    aksje$Aksjekursindeks[aksje$Aar == 2015L],
    100,
    tolerance = 1e-8
  )
})
