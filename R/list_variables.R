
list_variables <- function(category = NULL, type = NULL){
  
  metadata <- get_metadata()

  if(!is.null(category)){
    metadata <- metadata |>
      dplyr::filter(Kategori == category)
  }
  
  if(!is.null(type)){
    metadata <- metadata |>
      dplyr::filter(Type == type)
  }
  
  if(nrow(metadata) == 0){
    message("Ingen variabler funnet.")
    return(invisible(metadata))
  }
  
  cat("\n")
  cat("NorMacro variabler\n")
  cat(nrow(metadata), "variabler\n\n")
  
  categories <- sort(unique(metadata$Kategori))
  
  for(cat_name in categories){
    
    vars <- metadata |>
      dplyr::filter(Kategori == cat_name) |>
      dplyr::arrange(Variabel) |>
      dplyr::pull(Variabel)
    
    cat(cat_name, "\n")
    cat(strrep("-", nchar(cat_name)), "\n", sep = "")
    
    for(v in vars){
      cat("- ", v, "\n", sep = "")
    }
    
    cat("\n")
  }
  
  invisible(metadata)
}