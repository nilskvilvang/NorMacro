
# data-raw/normacro_international_example.R

international <- get_international_macro()
international_meta <- get_international_metadata()

international_example_countries <- c(
  "NO",
  "SE",
  "DK",
  "FI",
  "DE",
  "FR"
)

international_example_variables <- c(
  "Aar",
  "Land",
  "HICP",
  "Inflasjon",
  "Befolkning",
  "Arbeidsledighetsrate",
  "BNP_faste_priser",
  "BNP_vekst",
  "Sysselsatte",
  "Arbeidsstyrke",
  "Boligprisindeks",
  "Boligprisvekst",
  "Eksport",
  "Import"
)

normacro_international_example <- international |>
  dplyr::filter(
    Aar >= 2000,
    Aar <= 2025,
    Land %in% international_example_countries
  ) |>
  dplyr::select(
    dplyr::all_of(international_example_variables)
  ) |>
  dplyr::arrange(
    Land,
    Aar
  )

normacro_international_example_metadata <- international_meta |>
  dplyr::filter(
    Variabel %in% setdiff(
      international_example_variables,
      c("Aar", "Land")
    ),
    Omraade == "Internasjonal"
  ) |>
  dplyr::arrange(
    match(
      Variabel,
      setdiff(
        international_example_variables,
        c("Aar", "Land")
      )
    )
  )

stopifnot(
  nrow(normacro_international_example) == 156L,
  ncol(normacro_international_example) ==
    length(international_example_variables),
  nrow(normacro_international_example_metadata) ==
    length(international_example_variables) - 2L,
  !anyDuplicated(
    normacro_international_example_metadata$Variabel
  )
)

usethis::use_data(
  normacro_international_example,
  normacro_international_example_metadata,
  overwrite = TRUE,
  compress = "xz"
)
