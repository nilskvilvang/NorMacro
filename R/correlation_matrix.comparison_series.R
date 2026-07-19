

correlation_matrix.comparison_series <- function(x,
                                                 start_year = NULL,
                                                 end_year = NULL,
                                                 use = c("pairwise.complete.obs",
                                                         "complete.obs",
                                                         "everything",
                                                         "all.obs",
                                                         "na.or.complete"),
                                                 method = c("pearson", "spearman", "kendall"),
                                                 ...) {
  use <- match.arg(use)
  method <- match.arg(method)
  
  required_columns <- c("Aar", "Serie_id", "Verdi")
  
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
  
  number_of_series <- dplyr::n_distinct(analysis_data$Serie_id)
  
  if (number_of_series < 2) {
    stop("`correlation_matrix()` krever minst to serier.", call. = FALSE)
  }
  
  wide_data <- analysis_data |>
    dplyr::select(Aar, Serie_id, Verdi) |>
    tidyr::pivot_wider(names_from = Serie_id, values_from = Verdi) |>
    dplyr::arrange(.data$Aar)
  
  result <- wide_data |>
    dplyr::select(-Aar) |>
    stats::cor(use = use, method = method)
  
  attr(result, "method") <- method
  
  attr(result, "use") <- use
  
  attr(result, "start_year") <- start_year
  
  attr(result, "end_year") <- end_year
  
  attr(result, "transformation") <- attr(x, "transformation")
  
  attr(result, "transformation_periods") <- attr(x, "transformation_periods")
  
  attr(result, "base_year") <- attr(x, "base_year")
  
  attr(result, "transformation_base_value") <- attr(x, "transformation_base_value")
  
  class(result) <- c("comparison_series_correlation_matrix", class(result))
  
  result
}