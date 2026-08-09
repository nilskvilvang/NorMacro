

install_dependencies <- function() {
  packages <- c(
    "tidyverse",
    "rio",
    "PxWebApiData",
    "quantmod",
    "zoo",
    "testthat",
    "broom",
    "lmtest",
    "eurostat"
  )
  
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  
  if (length(missing) == 0) {
    message("\u2713 Alle n\u00f8dvendige pakker er installert.")
    return(invisible(TRUE))
  }
  
  message("Installerer manglende pakker: ",
          paste(missing, collapse = ", "))
  
  utils::install.packages(
    missing
  )
  
  invisible(TRUE)
}
