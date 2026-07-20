
normalize_series <- function(data = NULL,
                             variables,
                             base_year = NULL) {
  if (is.null(data)) {
    data <- suppressMessages(get_normacro())
  }
  
  missing <- setdiff(variables, names(data))
  
  if (length(missing) > 0) {
    stop("Fant ikke variabler i datasettet: ",
         paste(missing, collapse = ", "))
  }
  
  if (is.null(base_year)) {
    base_year <- min(data$Aar, na.rm = TRUE)
  }
  
  base_values <- data |>
    dplyr::filter(Aar == base_year) |>
    dplyr::select(dplyr::all_of(variables))
  
  if (nrow(base_values) == 0) {
    stop("Fant ikke base_year i datasettet: ", base_year)
  }
  
  data |>
    dplyr::select(Aar, dplyr::all_of(variables)) |>
    dplyr::mutate(dplyr::across(dplyr::all_of(variables), ~ .x / base_values[[dplyr::cur_column()]][1] * 100))
}
