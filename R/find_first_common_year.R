
find_first_common_year <- function(
    data,
    year_column = "Aar",
    series_column = "Serie_id",
    value_column = "Verdi"
) {
  
  required_columns <- c(
    year_column,
    series_column,
    value_column
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(data)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      "Datasettet mangler nødvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  if (nrow(data) == 0) {
    stop(
      "Datasettet inneholder ingen observasjoner.",
      call. = FALSE
    )
  }
  
  total_series <- data |>
    dplyr::filter(
      !is.na(.data[[series_column]])
    ) |>
    dplyr::distinct(
      .data[[series_column]]
    ) |>
    nrow()
  
  if (total_series == 0) {
    stop(
      "Fant ingen gyldige serier i datasettet.",
      call. = FALSE
    )
  }
  
  common_years <- data |>
    dplyr::filter(
      !is.na(.data[[year_column]]),
      !is.na(.data[[series_column]]),
      !is.na(.data[[value_column]])
    ) |>
    dplyr::distinct(
      .data[[series_column]],
      .data[[year_column]]
    ) |>
    dplyr::count(
      .data[[year_column]],
      name = "n_series"
    ) |>
    dplyr::filter(
      .data$n_series == .env$total_series
    ) |>
    dplyr::arrange(
      .data[[year_column]]
    )
  
  if (nrow(common_years) == 0) {
    stop(
      paste0(
        "Fant ingen felles år med gyldige verdier ",
        "for alle seriene."
      ),
      call. = FALSE
    )
  }
  
  common_years[[year_column]][[1]]
}