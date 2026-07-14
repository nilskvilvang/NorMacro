

list_categories <- function(data = NULL, print = TRUE) {
  metadata <- get_metadata(data)
  
  result <- metadata |>
    dplyr::count(.data$Kategori, name = "Antall") |>
    dplyr::arrange(.data$Kategori)
  
  idataset_name <- if (is.null(data)) {
    "Alle metadata"
  } else if ("Land" %in% names(data)) {
    "Internasjonale data"
  } else {
    "Norske data"
  }
  
  if (print) {
    cat("\n")
    cat(idataset_name, "\n")
    cat(strrep("-", nchar(idataset_name)), "\n", sep = "")
    cat(nrow(result), " kategorier\n", sep = "")
    cat(nrow(metadata), " variabler\n\n", sep = "")
    
    print(result, n = Inf)
  }
  
  invisible(result)
}
