
get_display_name <- function(variable, metadata = NULL) {
  
  if (is.null(metadata)) {
    metadata <- get_metadata()
  }
  
  display <- metadata |>
    dplyr::filter(.data$Variabel == variable) |>
    dplyr::pull(.data$Display_navn)
  
  if (length(display) == 0 || is.na(display[1]) || display[1] == "") {
    return(variable)
  }
  
  display[1]
}