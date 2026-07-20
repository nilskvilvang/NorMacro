

correlation_matrix.default <- function(x,
                                       data = NULL,
                                       start_year = NULL,
                                       end_year = NULL,
                                       use = "pairwise.complete.obs",
                                       method = "pearson",
                                       ...) {
  variables <- x
  
  if (is.null(data)) {
    data <- suppressMessages(get_normacro())
  }
  
  missing <- setdiff(variables, names(data))
  
  if (length(missing) > 0) {
    stop("Fant ikke variabler i datasettet: ",
         paste(missing, collapse = ", "),
         call. = FALSE)
  }
  
  data_subset <- data |>
    dplyr::select(Aar, dplyr::all_of(variables))
  
  if (!is.null(start_year)) {
    data_subset <- data_subset |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    data_subset <- data_subset |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  data_subset |>
    dplyr::select(-Aar) |>
    stats::cor(use = use, method = method)
}