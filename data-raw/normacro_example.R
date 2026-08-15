
# data-raw/normacro_example.R

nm <- get_normacro()
meta <- get_metadata()

example_variables <- c(
  "Aar",
  "KPI",
  "Inflasjon",
  "Befolkning",
  "Arbeidsstyrke",
  "Sysselsatte",
  "Arbeidsledige_NAV",
  "Arbeidsledighetsrate_NAV",
  "Styringsrente",
  "BNP_Fastland",
  "BNP_Fastland_vekst",
  "Lonnvekst",
  "Boligprisindeks",
  "Boligprisvekst",
  "Oljepris_USD",
  "Eksport",
  "Import"
)

normacro_example <- nm |>
  dplyr::filter(Aar >= 2000, Aar <= 2025) |>
  dplyr::select(dplyr::all_of(example_variables))

normacro_example_metadata <- meta |>
  dplyr::filter(
    Variabel %in% setdiff(example_variables, "Aar"),
    Omraade == "Norge"
  ) |>
  dplyr::arrange(
    match(Variabel, setdiff(example_variables, "Aar"))
  )

stopifnot(
  nrow(normacro_example) == 26L,
  ncol(normacro_example) == length(example_variables),
  nrow(normacro_example_metadata) ==
    length(example_variables) - 1L,
  !anyDuplicated(normacro_example_metadata$Variabel)
)

usethis::use_data(
  normacro_example,
  normacro_example_metadata,
  overwrite = TRUE,
  compress = "xz"
)

