
get_metadata <- function(data = NULL) {
  if (is.null(data)) {
    return(dplyr::bind_rows(get_normacro_metadata(), get_international_metadata()))
  }
  
  metadata <- if ("Land" %in% names(data)) {
    get_international_metadata()
  } else {
    get_normacro_metadata()
  }
  
  variables <- setdiff(names(data), c("Aar", "Land"))
  
  metadata |>
    dplyr::filter(.data$Variabel %in% variables)
}

