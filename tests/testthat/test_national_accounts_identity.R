
test_that("national accounts identity components have expected coverage", {
  x <- normacro |>
    dplyr::filter(
      !is.na(.data$Konsum_husholdninger_ideelle_lopende),
      !is.na(.data$Bruttoinvestering_i_alt_lopende)
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
})

test_that("national accounts identity holds in current prices", {
  x <- normacro |>
    dplyr::filter(
      !is.na(.data$BNP_lopende),
      !is.na(.data$Konsum_husholdninger_ideelle_lopende),
      !is.na(.data$Offentlig_konsum_lopende),
      !is.na(.data$Bruttoinvestering_i_alt_lopende),
      !is.na(.data$Eksport_lopende),
      !is.na(.data$Import_lopende)
    ) |>
    dplyr::mutate(
      Beregnet_BNP =
        .data$Konsum_husholdninger_ideelle_lopende +
        .data$Offentlig_konsum_lopende +
        .data$Bruttoinvestering_i_alt_lopende +
        .data$Eksport_lopende -
        .data$Import_lopende,
      Avvik =
        .data$BNP_lopende -
        .data$Beregnet_BNP
    )
  expect_lte(
    max(abs(x$Avvik)),
    20
  )
})
