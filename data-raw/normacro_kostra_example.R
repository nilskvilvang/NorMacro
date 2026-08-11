
# data-raw/normacro_kostra_example.R

normacro_kostra_example <- kostra_test_data

attr(
  normacro_kostra_example,
  "dataset_type"
) <- "kostra"

attr(
  normacro_kostra_example,
  "kostra_table"
) <- "12134"

attr(
  normacro_kostra_example,
  "kostra_title"
) <- "Utvalgte nøkkeltall for kommuneregnskap"

stopifnot(
  nrow(normacro_kostra_example) == 18L,
  ncol(normacro_kostra_example) == 7L,
  dplyr::n_distinct(normacro_kostra_example$Enhet) == 3L,
  min(normacro_kostra_example$Aar) == 2020L,
  max(normacro_kostra_example$Aar) == 2025L
)

usethis::use_data(
  normacro_kostra_example,
  overwrite = TRUE,
  compress = "xz"
)
