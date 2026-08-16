
test_that("historical_episodes returns curated catalogue", {
  x <- historical_episodes()
  
  expect_s3_class(x, "tbl_df")
  expect_equal(nrow(x), 5L)
  
  expect_true(
    all(
      c(
        "Episode_id",
        "Episode",
        "Startaar",
        "Sluttaar",
        "Tema",
        "Kort_beskrivelse",
        "Variabler"
      ) %in% names(x)
    )
  )
})


test_that("historical_episodes filters by episode", {
  x <- historical_episodes(
    episode = "finanskrisen_2008"
  )
  
  expect_equal(nrow(x), 1L)
  expect_equal(
    x$Episode_id[[1]],
    "finanskrisen_2008"
  )
})


test_that("historical_episodes filters themes case-insensitively", {
  x <- historical_episodes(
    theme = "FINANSKRISE"
  )
  
  expect_equal(nrow(x), 2L)
})


test_that("historical_episodes rejects unknown episodes", {
  expect_error(
    historical_episodes(
      episode = "finnes_ikke"
    ),
    "Fant ikke episode"
  )
})


test_that("all episode variables exist in Norwegian data", {
  episodes <- historical_episodes()
  
  variables <- unique(
    unlist(
      strsplit(
        episodes$Variabler,
        ";",
        fixed = TRUE
      )
    )
  )
  
  expect_identical(
    setdiff(
      variables,
      names(normacro)
    ),
    character()
  )
})
