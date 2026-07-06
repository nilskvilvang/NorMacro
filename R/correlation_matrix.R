
correlation_matrix <- function(
    variables,
    data = NULL,
    start_year = NULL,
    end_year = NULL,
    use = "pairwise.complete.obs",
    method = "pearson"
){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  missing <- setdiff(variables, names(data))
  
  if(length(missing) > 0){
    stop(
      "Fant ikke variabler i datasettet: ",
      paste(missing, collapse = ", ")
    )
  }
  
  data_subset <- data |>
    dplyr::select(Aar, dplyr::all_of(variables))
  
  if(!is.null(start_year)){
    data_subset <- data_subset |>
      dplyr::filter(Aar >= start_year)
  }
  
  if(!is.null(end_year)){
    data_subset <- data_subset |>
      dplyr::filter(Aar <= end_year)
  }
  
  data_subset |>
    dplyr::select(-Aar) |>
    stats::cor(
      use = use,
      method = method
    )
}
