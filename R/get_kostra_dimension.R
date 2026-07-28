
get_kostra_dimension <- function(url, code) {
  
  metadata <- pxweb::pxweb_get(url)
  
  variable <- get_px_variable(metadata, code)
  
  tibble::tibble(
    Code = variable$values,
    Text = variable$valueTexts
  )
}
