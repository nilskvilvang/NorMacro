
get_metadata <- function(data = NULL) {
  
  metadata <-
    dplyr::bind_rows(
      get_normacro_metadata(),
      get_international_metadata()
    )
  
  metadata
  
}

