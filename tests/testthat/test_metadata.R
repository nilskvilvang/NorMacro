
testthat::test_that(
  "all Norwegian variables have metadata",
  {
    norwegian_metadata <- metadata |>
      dplyr::filter(
        .data$Omraade == "Norge"
      )
    
    undocumented <- setdiff(
      names(normacro),
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
      names(metadata),
      expected_cols
    )
  }
)
