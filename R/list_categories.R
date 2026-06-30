
list_categories <- function(){
  
  metadata <- get_metadata()
  
    overview <- metadata |>
    dplyr::count(Kategori, name = "Antall") |>
    dplyr::arrange(Kategori)
  
  cat("\n")
  cat("NorMacro\n")
  cat(nrow(overview), "kategorier\n")
  cat(nrow(metadata), "variabler\n\n")
  
  print(overview, n = Inf)
  
  invisible(overview)
}