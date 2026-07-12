
correlate_series <- function(
    variables,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    method = "pearson",
    use = "pairwise.complete.obs"
) {
  
  if (is.null(data)) {
    data <- get_normacro()
  }
  
  metadata <- get_metadata(data)
  
  if (
    "Land" %in% names(data) &&
    dplyr::n_distinct(data$Land) > 1
  ) {
    stop(
      paste0(
        "correlate_series() kan analysere ett land om gangen. ",
        "Filtrer data til ett land først."
      ),
      call. = FALSE
    )
  }
  
  missing <- setdiff(variables, names(data))
  
  if (length(missing) > 0) {
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  analysis_data <- data
  
  if (!is.null(start_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar >= start_year)
  }
  
  if (!is.null(end_year)) {
    analysis_data <- analysis_data |>
      dplyr::filter(.data$Aar <= end_year)
  }
  
  correlation_matrix <- analysis_data |>
    dplyr::select(
      dplyr::all_of(variables)
    ) |>
    stats::cor(
      use = use,
      method = method
    )
  
  display_lookup <- tibble::tibble(
    Variabel = variables,
    Display_navn = vapply(
      variables,
      get_display_name,
      character(1),
      metadata = metadata
    )
  )
  
  dimnames(correlation_matrix) <- list(
    display_lookup$Display_navn,
    display_lookup$Display_navn
  )
  
  correlation_matrix
}