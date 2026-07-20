

check_metadata <- function(data,
                           metadata = NULL,
                           ignore = c("Aar", "Land"),
                           verbose = FALSE) {
  if (is.null(metadata)) {
    metadata <- get_metadata(data)
  }
  
  missing_vars <- setdiff(names(data), c(metadata$Variabel, ignore))
  
  if (length(missing_vars) == 0) {
    if (verbose) {
      message("✓ Alle variabler er dokumentert i metadata.")
    }
    
  } else {
    warning(paste(
      "Variabler uten metadata:",
      paste(missing_vars, collapse = ", ")
    ), call. = FALSE)
  }
  
  invisible(missing_vars)
}