
get_px_variable <- function(metadata, code) {
  variable <- purrr::detect(metadata$variables, ~ identical(.x$code, code))
  
  if (is.null(variable)) {
    stop("Fant ikke variabelen i PXWeb-metadata: ", code, call. = FALSE)
  }
  
  variable
}
