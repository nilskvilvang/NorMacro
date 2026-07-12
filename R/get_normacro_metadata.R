
get_normacro_metadata <- function() {
  
  readr::read_csv(
    "data/metadata.csv",
    show_col_types = FALSE,
    na = c("", "NA")
  ) |>
    dplyr::mutate(
      Omraade = dplyr::coalesce(
        .data$Omraade,
        "Norge"
      )
    )
}
