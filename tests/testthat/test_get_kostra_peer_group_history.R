
testthat::test_that(
  "get_kostra_peer_group_history returns historical peers",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_history(
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    testthat::expect_true(
      all(
        c(
          "Enhet",
          "Enhet_navn",
          "Aar",
          "KOSTRA_gruppe",
          "KOSTRA_gruppe_navn"
        ) %in% names(result)
      )
    )
    
    testthat::expect_true(
      all(
        result$KOSTRA_gruppe == "EKG12"
      )
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_history returns 11 group 12 units each year",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_history(
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    counts <- result |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
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
  "get_kostra_peer_group_history includes selected unit every year",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_history(
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    selected <- result |>
      dplyr::filter(
        .data$Enhet == "1103"
      )
    
    testthat::expect_equal(
      selected$Aar,
      2020:2025
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_history uses historical municipality codes",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_history(
      unit = "1103",
      start_year = 2020,
      end_year = 2025
    )
    
    peers_2020 <- result |>
      dplyr::filter(
        .data$Aar == 2020
      )
    
    peers_2025 <- result |>
      dplyr::filter(
        .data$Aar == 2025
      )
    
    testthat::expect_true(
      "3004" %in% peers_2020$Enhet
    )
    
    testthat::expect_true(
      "3024" %in% peers_2020$Enhet
    )
    
    testthat::expect_true(
      "3107" %in% peers_2025$Enhet
    )
    
    testthat::expect_true(
      "3201" %in% peers_2025$Enhet
    )
  }
)


testthat::test_that(
  "get_kostra_peer_group_history returns Oslo alone in group 13",
  {
    
    skip_if_not_live_api()
    
    result <- get_kostra_peer_group_history(
      unit = "0301",
      start_year = 2020,
      end_year = 2025
    )
    
    counts <- result |>
      dplyr::count(
        .data$Aar,
        name = "Antall"
      )
    
    testthat::expect_equal(
      counts$Antall,
      rep(
        1L,
        6
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
  "get_kostra_peer_group_history rejects unknown units",
  {
    
    skip_if_not_live_api()
    
    testthat::expect_error(
      get_kostra_peer_group_history(
        unit = "9999",
        start_year = 2020,
        end_year = 2025
      ),
      "Fant ikke KOSTRA-enheten"
    )
  }
)