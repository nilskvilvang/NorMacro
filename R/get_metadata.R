
get_metadata <- function(data = NULL) {
  
  metadata_norway <- get_normacro_metadata()
  metadata_international <- get_international_metadata()
  
  if (is.null(data)) {
    return(
      dplyr::bind_rows(
        metadata_norway,
        metadata_international
      )
    )
  }
  
  metadata <- if ("Land" %in% names(data)) {
    metadata_international
  } else {
    metadata_norway
  }
  
  variables <- setdiff(
    names(data),
    c("Aar", "Land")
  )
  
  metadata |>
    dplyr::filter(.data$Variabel %in% variables)
}
