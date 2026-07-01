
testthat::test_that("All variables have metadata", {
  undocumented <- setdiff(names(normacro), c(metadata$Variabel, "Aar"))
  
  testthat::expect_equal(undocumented, character(0))
})

testthat::test_that("Metadata has expected columns", {
  expected_cols <- c(
    "Variabel", "Type", "Kategori", "Beskrivelse", "Kilde",
    "Kilde_url", "Tabell", "Enhet", "Frekvens",
    "Startaar", "Sluttaar", "Funksjon", "Kommentar"
  )
  
  testthat::expect_equal(names(metadata), expected_cols)
})