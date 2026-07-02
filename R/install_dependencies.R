
install_dependencies <- function(){
  
  packages <- c(
    "tidyverse",
    "rio",
    "PxWebApiData",
    "quantmod",
    "zoo",
    "readr",
    "testthat"
  )
  
  missing <- packages[
    !vapply(packages, requireNamespace, logical(1), quietly = TRUE)
  ]
  
  if(length(missing) == 0){
    message("✓ Alle nødvendige pakker er installert.")
    return(invisible(TRUE))
  }
  
  message("Installerer manglende pakker: ", paste(missing, collapse = ", "))
  
  install.packages(missing)
  
  invisible(TRUE)
}