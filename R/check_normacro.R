
check_normacro <- function(data, verbose = FALSE) {
  
  checks <- list(
    has_aar = "Aar" %in% names(data),
    aar_sorted = identical(data$Aar, sort(data$Aar)),
    no_duplicate_years = !anyDuplicated(data$Aar),
    metadata_ok = length(check_metadata(data, verbose = verbose)) == 0
  )
  
  failed <- names(checks)[!unlist(checks)]
  
  if (length(failed) == 0) {
    
    if (verbose) {
      message("✓ NorMacro bestod alle kvalitetskontroller.")
    }
    
  } else {
    
    warning(
      paste(
        "Kvalitetskontroller feilet:",
        paste(failed, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  
  invisible(checks)
}