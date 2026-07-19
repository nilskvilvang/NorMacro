
summary.comparison_series <- function(
    object,
    ...
) {
  
  required_columns <- c(
    "Aar",
    "Serie_id",
    "Display_navn",
    "Verdi"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(object)
  )
  
  if (length(missing_columns) > 0) {
    stop(
      "Mangler nødvendige kolonner: ",
      paste(
        missing_columns,
        collapse = ", "
      ),
      ".",
      call. = FALSE
    )
  }
  
  data <- tibble::as_tibble(object)
  
  result <- data |>
    dplyr::group_by(
      .data$Serie_id,
      .data$Display_navn
    ) |>
    dplyr::summarise(
      Foerste_aar = as.integer(
        min(
          .data$Aar,
          na.rm = TRUE
        )
      ),
      Siste_aar = as.integer(
        max(
          .data$Aar,
          na.rm = TRUE
        )
      ),
      Foerste_gyldige_aar = {
        valid_years <- .data$Aar[
          !is.na(.data$Verdi)
        ]
        
        if (length(valid_years) == 0) {
          NA_integer_
        } else {
          as.integer(
            min(valid_years)
          )
        }
      },
      Siste_gyldige_aar = {
        valid_years <- .data$Aar[
          !is.na(.data$Verdi)
        ]
        
        if (length(valid_years) == 0) {
          NA_integer_
        } else {
          as.integer(
            max(valid_years)
          )
        }
      },
      Observasjoner = sum(
        !is.na(.data$Verdi)
      ),
      Manglende = sum(
        is.na(.data$Verdi)
      ),
      Gjennomsnitt = if (
        all(is.na(.data$Verdi))
      ) {
        NA_real_
      } else {
        mean(
          .data$Verdi,
          na.rm = TRUE
        )
      },
      Median = if (
        all(is.na(.data$Verdi))
      ) {
        NA_real_
      } else {
        stats::median(
          .data$Verdi,
          na.rm = TRUE
        )
      },
      Minimum = if (
        all(is.na(.data$Verdi))
      ) {
        NA_real_
      } else {
        min(
          .data$Verdi,
          na.rm = TRUE
        )
      },
      Maksimum = if (
        all(is.na(.data$Verdi))
      ) {
        NA_real_
      } else {
        max(
          .data$Verdi,
          na.rm = TRUE
        )
      },
      Standardavvik = if (
        sum(!is.na(.data$Verdi)) < 2
      ) {
        NA_real_
      } else {
        stats::sd(
          .data$Verdi,
          na.rm = TRUE
        )
      },
      .groups = "drop"
    )
  
  attr(
    result,
    "transformation"
  ) <- attr(
    object,
    "transformation"
  )
  
  attr(
    result,
    "transformation_periods"
  ) <- attr(
    object,
    "transformation_periods"
  )
  
  attr(
    result,
    "base_year"
  ) <- attr(
    object,
    "base_year"
  )
  
  attr(
    result,
    "transformation_base_value"
  ) <- attr(
    object,
    "transformation_base_value"
  )
  
  class(result) <- c(
    "comparison_series_summary",
    class(result)
  )
  
  result
}
