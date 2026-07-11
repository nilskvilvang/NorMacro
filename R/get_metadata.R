
get_metadata <- function(data = NULL) {
  
  metadata_norway <- readr::read_csv(
    "data/metadata.csv",
    show_col_types = FALSE,
    na = c("", "NA")
  )
  
  metadata_international <- readr::read_csv(
    "data/metadata_international.csv",
    show_col_types = FALSE,
    na = c("", "NA")
  )
  
  if (is.null(data)) {
    return(
      dplyr::bind_rows(
        metadata_norway |>
          dplyr::mutate(Omraade = "Norge"),
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
