
get_kostra_dimension_metadata <- function(
    url,
    code
) {
  metadata <- pxweb::pxweb_get(url)
  
  variable <- get_px_variable(
    metadata = metadata,
    code = code
  )
  
  tibble::tibble(
    Code = as.character(variable$values),
    Display_navn = as.character(variable$valueTexts)
  )
}
