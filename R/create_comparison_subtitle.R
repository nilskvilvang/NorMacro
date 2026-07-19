
create_comparison_subtitle <- function(x) {
  
  required_columns <- c(
    "Aar",
    "Verdi"
  )
  
  if (!all(required_columns %in% names(x))) {
    return(NULL)
  }
  
  years <- x$Aar[
    !is.na(x$Aar) &
      !is.na(x$Verdi)
  ]
  
  if (length(years) == 0) {
    return(NULL)
  }
  
  first_year <- min(years)
  last_year <- max(years)
  
  if (first_year == last_year) {
    return(
      as.character(first_year)
    )
  }
  
  paste0(
    first_year,
    "\u2013",
    last_year
  )
}
