

correlate.comparison_series <- function(x,
                                        method = c("pearson", "spearman", "kendall"),
                                        start_year = NULL,
                                        end_year = NULL,
                                        include_diagonal = FALSE,
                                        format = TRUE,
                                        ...) {
  method <- match.arg(method)
  
  required_columns <- c("Aar", "Serie_id", "Display_navn", "Verdi")
  
  missing_columns <- setdiff(required_columns, names(x))
  
  if (length(missing_columns) > 0) {
    stop(
      "Mangler nødvendige kolonner: ",
      paste(missing_columns, collapse = ", "),
      ".",
      call. = FALSE
    )
  }
  
  validate_year <- function(value, argument) {
    if (is.null(value)) {
      return(invisible(NULL))
    }
    
    if (!is.numeric(value) ||
        length(value) != 1 ||
        is.na(value) ||
        !is.finite(value)) {
      stop("`", argument, "` må være ett endelig numerisk år.", call. = FALSE)
    }
    
    invisible(NULL)
  }
  
  validate_year(start_year, "start_year")
  
  validate_year(end_year, "end_year")
  
  if (!is.null(start_year) &&
      !is.null(end_year) &&
      start_year > end_year) {
    stop("`start_year` kan ikke være større enn `end_year`.", call. = FALSE)
  }
  
  if (!is.logical(include_diagonal) ||
      length(include_diagonal) != 1 ||
      is.na(include_diagonal)) {
    stop("`include_diagonal` må være TRUE eller FALSE.", call. = FALSE)
  }
  
  if (!is.logical(format) ||
      length(format) != 1 ||
      is.na(format)) {
    stop("`format` må være TRUE eller FALSE.", call. = FALSE)
  }
  
  analysis_data <- tibble::as_tibble(x)
  
  if (!is.null(start_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  if (nrow(analysis_data) == 0) {
    stop("Fant ingen observasjoner i valgt periode.", call. = FALSE)
  }
  
  series_ids <- analysis_data |>
    dplyr::distinct(.data$Serie_id) |>
    dplyr::pull(.data$Serie_id)
  
  if (length(series_ids) < 2) {
    stop("`correlate()` krever minst to serier.", call. = FALSE)
  }
  
  series_pairs <- if (include_diagonal) {
    pair_grid <- expand.grid(
      Serie_1 = series_ids,
      Serie_2 = series_ids,
      stringsAsFactors = FALSE
    )
    
    pair_grid[match(pair_grid$Serie_1, series_ids) <=
                match(pair_grid$Serie_2, series_ids), , drop = FALSE] |>
      split(seq_len(nrow(pair_grid[match(pair_grid$Serie_1, series_ids) <=
                                     match(pair_grid$Serie_2, series_ids), , drop = FALSE]))) |>
      lapply(function(pair) {
        c(pair$Serie_1[[1]], pair$Serie_2[[1]])
      })
    
  } else {
    utils::combn(series_ids, 2, simplify = FALSE)
  }
  
  display_lookup <- analysis_data |>
    dplyr::distinct(.data$Serie_id, .data$Display_navn)
  
  results <- lapply(series_pairs, function(pair) {
    serie_1 <- pair[[1]]
    serie_2 <- pair[[2]]
    
    series_1_data <- analysis_data |>
      dplyr::filter(.data$Serie_id == serie_1) |>
      dplyr::select(Aar, Verdi_1 = Verdi)
    
    series_2_data <- analysis_data |>
      dplyr::filter(.data$Serie_id == serie_2) |>
      dplyr::select(Aar, Verdi_2 = Verdi)
    
    pair_data <- dplyr::inner_join(series_1_data, series_2_data, by = "Aar") |>
      dplyr::filter(!is.na(.data$Verdi_1), !is.na(.data$Verdi_2)) |>
      dplyr::arrange(.data$Aar)
    
    number_of_observations <- nrow(pair_data)
    
    start_year_pair <- if (number_of_observations == 0) {
      NA_real_
    } else {
      min(pair_data$Aar)
    }
    
    end_year_pair <- if (number_of_observations == 0) {
      NA_real_
    } else {
      max(pair_data$Aar)
    }
    
    if (number_of_observations < 3) {
      correlation <- NA_real_
      p_value <- NA_real_
      
    } else {
      correlation_test <- stats::cor.test(pair_data$Verdi_1,
                                          pair_data$Verdi_2,
                                          method = method,
                                          exact = FALSE)
      
      correlation <- unname(correlation_test$estimate)
      
      p_value <- correlation_test$p.value
    }
    
    tibble::tibble(
      Serie_1 = serie_1,
      Serie_2 = serie_2,
      Korrelasjon = correlation,
      P_verdi = p_value,
      Antall_observasjoner =
        number_of_observations,
      Metode = method,
      Startaar = start_year_pair,
      Sluttaar = end_year_pair
    )
  })
  
  result <- dplyr::bind_rows(results) |>
    dplyr::left_join(display_lookup |>
                       dplyr::rename(Serie_1 = Serie_id, Display_1 = Display_navn),
                     by = "Serie_1") |>
    dplyr::left_join(display_lookup |>
                       dplyr::rename(Serie_2 = Serie_id, Display_2 = Display_navn),
                     by = "Serie_2") |>
    dplyr::mutate(
      Signifikant = dplyr::case_when(
        is.na(.data$P_verdi) ~ NA_character_,
        .data$P_verdi < 0.001 ~ "***",
        .data$P_verdi < 0.01 ~ "**",
        .data$P_verdi < 0.05 ~ "*",
        TRUE ~ ""
      )
    ) |>
    dplyr::arrange(dplyr::desc(abs(.data$Korrelasjon)))
  
  if (format) {
    result <- result |>
      dplyr::mutate(
        Korrelasjon = format_number(.data$Korrelasjon, digits = 3),
        P_verdi = format_pvalue(.data$P_verdi)
      )
  }
  
  result <- result |>
    dplyr::select(
      Serie_1,
      Display_1,
      Serie_2,
      Display_2,
      Korrelasjon,
      P_verdi,
      Signifikant,
      Antall_observasjoner,
      Metode,
      Startaar,
      Sluttaar
    )
  
  attr(result, "method") <- method
  
  attr(result, "start_year") <- start_year
  
  attr(result, "end_year") <- end_year
  
  attr(result, "include_diagonal") <- include_diagonal
  
  attr(result, "formatted") <- format
  
  attr(result, "transformation") <- attr(x, "transformation")
  
  attr(result, "transformation_periods") <- attr(x, "transformation_periods")
  
  attr(result, "base_year") <- attr(x, "base_year")
  
  attr(result, "transformation_base_value") <- attr(x, "transformation_base_value")
  
  class(result) <- c("comparison_series_correlation", class(result))
  
  result
}
