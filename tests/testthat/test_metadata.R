
testthat::test_that(
  "all Norwegian variables have metadata",
  {
    normacro_test <- normacro
    metadata_test <- metadata

    norwegian_metadata <- metadata_test |>
      dplyr::filter(
        .data$Omraade == "Norge"
      )

    undocumented <- setdiff(
      names(normacro_test),
      c(
        norwegian_metadata$Variabel,
        "Aar"
      )
    )

    testthat::expect_identical(
      undocumented,
      character()
    )
  }
)

testthat::test_that(
  "Metadata has expected columns",
  {
    metadata_test <- metadata

    expected_cols <- c(
      "Variabel",
      "Display_navn",
      "Type",
      "Kategori",
      "Beskrivelse",
      "Kilde",
      "Kilde_url",
      "Tabell",
      "Enhet",
      "Frekvens",
      "Startaar",
      "Sluttaar",
      "Funksjon",
      "Kommentar",
      "Omraade",
      "Analyse_type"
    )

    testthat::expect_identical(
      names(metadata_test),
      expected_cols
    )
  }
)
