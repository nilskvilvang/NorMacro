
growth.comparison_series <- function(
    x,
    periods = 1,
    percent = TRUE,
    ...
) {
  
  required_columns <- c(
    "Aar",
    "Serie_id",
    "Verdi",
    "Enhet"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(x)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      "Objektet mangler nødvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  if (
    !is.numeric(periods) ||
    length(periods) != 1 ||
    is.na(periods) ||
    periods < 1 ||
    periods != floor(periods)
  ) {
    stop(
      "`periods` må være et positivt heltall.",
      call. = FALSE
    )
  }
  
  periods <- as.integer(periods)
  
  if (
    !is.logical(percent) ||
    length(percent) != 1 ||
    is.na(percent)
  ) {
    stop(
      "`percent` må være TRUE eller FALSE.",
      call. = FALSE
    )
  }
  
  result <- x |>
    tibble::as_tibble() |>
    dplyr::arrange(
      .data$Serie_id,
      .data$Aar
    ) |>
    dplyr::group_by(
      .data$Serie_id
    ) |>
    dplyr::mutate(
      Previous_value = dplyr::lag(
        .data$Verdi,
        n = periods
      ),
      Verdi = if (percent) {
        100 * (
          .data$Verdi /
            .data$Previous_value -
            1
        )
      } else {
        .data$Verdi -
          .data$Previous_value
      }
    ) |>
    dplyr::ungroup() |>
    dplyr::select(
      -Previous_value
    )
  
  if (percent) {
    
    result <- result |>
      dplyr::mutate(
        Enhet = if (periods == 1) {
          "Prosentvis vekst"
        } else {
          paste0(
            "Prosentvis vekst over ",
            periods,
            " perioder"
          )
        }
      )
    
    transformation <- "growth_percent"
    
  } else {
    
    result <- result |>
      dplyr::mutate(
        Enhet = if (periods == 1) {
          paste0(
            "Absolutt endring (",
            .data$Enhet,
            ")"
          )
        } else {
          paste0(
            "Absolutt endring over ",
            periods,
            " perioder (",
            .data$Enhet,
            ")"
          )
        }
      )
    
    transformation <- "growth_absolute"
  }
  
  new_comparison_series(
    result,
    normalized = FALSE,
    base_year = NULL,
    transformation = transformation,
    transformation_periods = periods
  )
}
