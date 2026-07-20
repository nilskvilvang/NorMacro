

display_name <- function(variable) {
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(Variabel == variable) |>
    dplyr::pull(Display_navn)
  
  if (length(result) == 0 || is.na(result[1]) || result[1] == "") {
    return(variable)
  }
  
  result[1]
}
