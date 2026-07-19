
autocorrelate.comparison_series <- function(
    x,
    lags = 1:5,
    start_year = NULL,
    end_year = NULL,
    use = c(
      "pairwise.complete.obs",
      "complete.obs",
      "everything",
      "all.obs",
      "na.or.complete"
    ),
    method = c(
      "pearson",
      "spearman",
      "kendall"
    ),
    format = TRUE,
    ...
) {
  
  use <- match.arg(
    use
  )
  
  method <- match.arg(
    method
  )
  
  required_columns <- c(
    "Aar",
    "Serie_id",
    "Display_navn",
    "Verdi"
  )
  
  missing_columns <- setdiff(
    required_columns,
    names(x)
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
  
  validate_year <- function(
    value,
    argument
  ) {
    
    if (is.null(value)) {
      return(
        invisible(NULL)
      )
    }
    
    if (
      !is.numeric(value) ||
      length(value) != 1 ||
      is.na(value) ||
      !is.finite(value)
    ) {
      stop(
        "`",
        argument,
        "` må være ett endelig numerisk år.",
        call. = FALSE
      )
    }
    
    invisible(NULL)
  }
  
  validate_year(
    start_year,
    "start_year"
  )
  
  validate_year(
    end_year,
    "end_year"
  )
  
  if (
    !is.null(start_year) &&
    !is.null(end_year) &&
    start_year > end_year
  ) {
    stop(
      "`start_year` kan ikke være større enn `end_year`.",
      call. = FALSE
    )
  }
  
  if (
    !is.numeric(lags) ||
    length(lags) == 0 ||
    anyNA(lags) ||
    any(!is.finite(lags)) ||
    any(lags <= 0) ||
    any(lags != floor(lags))
  ) {
    stop(
      "`lags` må være en vektor med positive heltall.",
      call. = FALSE
    )
  }
  
  lags <- sort(
    unique(
      as.integer(lags)
    )
  )
  
  if (
    !is.logical(format) ||
    length(format) != 1 ||
    is.na(format)
  ) {
    stop(
      "`format` må være TRUE eller FALSE.",
      call. = FALSE
    )
  }
  
  analysis_data <- tibble::as_tibble(
    x
  )
  
  if (!is.null(start_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(
        .data$Aar >= start_year
      )
  }
  
  if (!is.null(end_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(
        .data$Aar <= end_year
      )
  }
  
  if (nrow(analysis_data) == 0) {
    stop(
      "Fant ingen observasjoner i valgt periode.",
      call. = FALSE
    )
  }
  
  duplicate_years <- analysis_data |>
    dplyr::count(
      .data$Serie_id,
      .data$Aar,
      name = "Antall"
    ) |>
    dplyr::filter(
      .data$Antall > 1
    )
  
  if (nrow(duplicate_years) > 0) {
    stop(
      "Hver serie må ha maksimalt én observasjon per år.",
      call. = FALSE
    )
  }
  
  series_lookup <- analysis_data |>
    dplyr::distinct(
      .data$Serie_id,
      .data$Display_navn
    )
  
  series_ids <- series_lookup |>
    dplyr::pull(
      .data$Serie_id
    )
  
  results <- lapply(
    series_ids,
    function(series_id) {
      
      series_data <- analysis_data |>
        dplyr::filter(
          .data$Serie_id == series_id
        ) |>
        dplyr::select(
          Aar,
          Verdi
        ) |>
        dplyr::arrange(
          .data$Aar
        )
      
      lag_results <- lapply(
        lags,
        function(lag_value) {
          
          current_data <- series_data |>
            dplyr::rename(
              Verdi = Verdi
            )
          
          lagged_data <- series_data |>
            dplyr::transmute(
              Aar = .data$Aar + lag_value,
              Verdi_lag = .data$Verdi
            )
          
          pair_data <- dplyr::inner_join(
            current_data,
            lagged_data,
            by = "Aar"
          ) |>
            dplyr::arrange(
              .data$Aar
            )
          
          valid_pairs <- pair_data |>
            dplyr::filter(
              !is.na(.data$Verdi),
              !is.na(.data$Verdi_lag)
            )
          
          number_of_observations <- nrow(
            valid_pairs
          )
          
          start_year_pair <- if (
            number_of_observations == 0
          ) {
            NA_real_
          } else {
            min(
              valid_pairs$Aar
            )
          }
          
          end_year_pair <- if (
            number_of_observations == 0
          ) {
            NA_real_
          } else {
            max(
              valid_pairs$Aar
            )
          }
          
          autocorrelation <- if (
            number_of_observations < 2
          ) {
            NA_real_
          } else {
            suppressWarnings(
              stats::cor(
                pair_data$Verdi,
                pair_data$Verdi_lag,
                use = use,
                method = method
              )
            )
          }
          
          tibble::tibble(
            Serie_id = series_id,
            Lag = lag_value,
            Autokorrelasjon = autocorrelation,
            Antall_observasjoner =
              number_of_observations,
            Startaar = start_year_pair,
            Sluttaar = end_year_pair
          )
        }
      )
      
      dplyr::bind_rows(
        lag_results
      )
    }
  )
  
  result <- dplyr::bind_rows(
    results
  ) |>
    dplyr::left_join(
      series_lookup,
      by = "Serie_id"
    ) |>
    dplyr::select(
      Serie_id,
      Display_navn,
      Lag,
      Autokorrelasjon,
      Antall_observasjoner,
      Startaar,
      Sluttaar
    ) |>
    dplyr::arrange(
      .data$Serie_id,
      .data$Lag
    )
  
  if (format) {
    result <- result |>
      dplyr::mutate(
        Autokorrelasjon = format_number(
          .data$Autokorrelasjon,
          digits = 3
        )
      )
  }
  
  attr(
    result,
    "lags"
  ) <- lags
  
  attr(
    result,
    "method"
  ) <- method
  
  attr(
    result,
    "use"
  ) <- use
  
  attr(
    result,
    "start_year"
  ) <- start_year
  
  attr(
    result,
    "end_year"
  ) <- end_year
  
  attr(
    result,
    "formatted"
  ) <- format
  
  attr(
    result,
    "transformation"
  ) <- attr(
    x,
    "transformation"
  )
  
  attr(
    result,
    "transformation_periods"
  ) <- attr(
    x,
    "transformation_periods"
  )
  
  attr(
    result,
    "base_year"
  ) <- attr(
    x,
    "base_year"
  )
  
  attr(
    result,
    "transformation_base_value"
  ) <- attr(
    x,
    "transformation_base_value"
  )
  
  class(result) <- c(
    "comparison_series_autocorrelation",
    class(result)
  )
  
  result
}