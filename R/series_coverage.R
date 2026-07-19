
series_coverage <- function(data) {
  
  data |>
    dplyr::group_by(
      .data$Serie_id
    ) |>
    dplyr::summarise(
      first_row_year = min(
        .data$Aar,
        na.rm = TRUE
      ),
      first_valid_year = min(
        .data$Aar[!is.na(.data$Verdi)],
        na.rm = TRUE
      ),
      last_valid_year = max(
        .data$Aar[!is.na(.data$Verdi)],
        na.rm = TRUE
      ),
      observations = sum(
        !is.na(.data$Verdi)
      ),
      missing_values = sum(
        is.na(.data$Verdi)
      ),
      .groups = "drop"
    )
}