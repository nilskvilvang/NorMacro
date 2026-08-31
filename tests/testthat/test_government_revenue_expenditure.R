
test_that(
  "government revenue and expenditure have expected coverage",
  {
    skip_if_not_live_api()

    x <- get_government_revenue_expenditure()

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
      sort(get_standard_countries())
    )

    expect_equal(
      coverage$Startaar[coverage$Land == "FI"],
      1980L
    )

    expect_true(
      all(
        coverage$Startaar[
          coverage$Land != "FI"
        ] == 1995L
      )
    )

    expect_true(
      all(coverage$Sluttaar >= 2025L)
    )

    expect_false(
      anyNA(x$Offentlige_inntekter_andel_BNP)
    )

    expect_false(
      anyNA(x$Offentlige_utgifter_andel_BNP)
    )

    expect_equal(
      anyDuplicated(x[c("Land", "Aar")]),
      0L
    )
  }
)
