
test_that(
  "inflation expectations have expected annual coverage",
  {
    x <- normacro |>
      dplyr::filter(
        !is.na(.data$Inflasjonsforventninger_5aar)
      )
    expect_equal(
      min(x$Aar),
      2002L
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
    expect_false(
      anyNA(x$Inflasjonsforventninger_5aar)
    )
  }
)

test_that(
  "get_inflation_expectations returns complete calendar years",
  {
    skip_if_not_live_api()

    x <- get_inflation_expectations()

    expect_equal(
      min(x$Aar),
      2002L
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
    expect_false(
      anyNA(x$Inflasjonsforventninger_5aar)
    )
  }
)
