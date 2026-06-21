
check_normacro <- function(data){
  
  checks <- list(
    has_aar = "Aar" %in% names(data),
    aar_sorted = identical(data$Aar, sort(data$Aar)),
    no_duplicate_years = !anyDuplicated(data$Aar),
    metadata_ok = length(check_metadata(data)) == 0
  )
  
  failed <- names(checks)[!unlist(checks)]
  
  if(length(failed) == 0){
    message("✓ NorMacro bestod alle kvalitetskontroller.")
  } else {
    warning(
      paste(
        "Kvalitetskontroller feilet:",
        paste(failed, collapse = ", ")
      )
    )
  }
  
  invisible(checks)
}