
testthat::test_that(
  "get_kostra_peer_group_data returns historical peer group data",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "1103",
      years = 2020:2025
    )
    
    testthat::expect_true(
      all(
        c(
          "Enhet",
          "Enhet_navn",
          "Enhetstype",
          "Aar",
          "KOSTRA_gruppe",
          "KOSTRA_gruppe_navn"
        ) %in% names(result)
      )
    )
    
    testthat::expect_equal(
      min(result$Aar),
      2020
    )
    
    testthat::expect_equal(
      max(result$Aar),
      2025
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data returns complete Stavanger peer group each year",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "1103",
      years = 2020:2025
    )
    
    counts <- result |>
      dplyr::distinct(
        .data$Aar,
        .data$Enhet
      ) |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
      )
    
    testthat::expect_equal(
      counts$Aar,
      2020:2025
    )
    
    testthat::expect_equal(
      counts$Antall,
      rep(
        11L,
        6
      )
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data uses historical municipality codes",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "1103",
      years = 2020:2025
    )
    
    units_2020 <- result |>
      dplyr::filter(
        .data$Aar == 2020
      ) |>
      dplyr::pull(
        .data$Enhet
      ) |>
      unique()
    
    units_2025 <- result |>
      dplyr::filter(
        .data$Aar == 2025
      ) |>
      dplyr::pull(
        .data$Enhet
      ) |>
      unique()
    
    testthat::expect_true(
      "3004" %in% units_2020
    )
    
    testthat::expect_true(
      "3024" %in% units_2020
    )
    
    testthat::expect_true(
      "3107" %in% units_2025
    )
    
    testthat::expect_true(
      "3201" %in% units_2025
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data keeps selected unit in every year",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "1103",
      years = 2020:2025
    )
    
    selected <- result |>
      dplyr::filter(
        .data$Enhet == "1103"
      ) |>
      dplyr::distinct(
        .data$Aar
      )
    
    testthat::expect_equal(
      selected$Aar,
      2020:2025
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data adds group metadata",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "1103",
      years = 2020:2025
    )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe == "EKG12"
      )
    )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe_navn ==
          "KOSTRA-gruppe 12"
      )
    )
    
    testthat::expect_equal(
      attr(
        result,
        "kostra_peer_unit"
      ),
      "1103"
    )
    
    testthat::expect_equal(
      attr(
        result,
        "kostra_group_definition"
      ),
      "historical"
    )
    
    testthat::expect_equal(
      attr(
        result,
        "kostra_group_start_year"
      ),
      2020L
    )
    
    testthat::expect_equal(
      attr(
        result,
        "kostra_group_end_year"
      ),
      2025L
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data returns Oslo alone in group 13",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "0301",
      years = 2024:2025
    )
    
    counts <- result |>
      dplyr::distinct(
        .data$Aar,
        .data$Enhet
      ) |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
      )
    
    testthat::expect_equal(
      counts$Antall,
      c(
        1L,
        1L
      )
    )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe == "EKG13"
      )
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data supports non-contiguous years",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_data(
      unit = "1103",
      years = c(
        2020,
        2022,
        2025
      )
    )
    
    testthat::expect_equal(
      sort(
        unique(
          result$Aar
        )
      ),
      c(
        2020L,
        2022L,
        2025L
      )
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data rejects unknown units",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_peer_group_data(
        unit = "9999",
        years = 2020:2025
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data rejects invalid years",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_peer_group_data(
        unit = "1103",
        years = character()
      ),
      "`years`"
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_data rejects unsupported tables",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_peer_group_data(
        unit = "1103",
        years = 2025,
        table = "99999"
      ),
      "støttes ikke"
    )
  }
)