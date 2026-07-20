
list_variables <- function(data = NULL,
                           category = NULL,
                           type = NULL,
                           print = TRUE) {
  metadata <- get_metadata(data)
  
  if (!is.null(category)) {
    metadata <- metadata |>
      dplyr::filter(.data$Kategori == category)
  }
  
  if (!is.null(type)) {
    metadata <- metadata |>
      dplyr::filter(.data$Type == type)
  }
  
  if (nrow(metadata) == 0) {
    message("Fant ingen variabler med valgte kriterier.")
    return(invisible(metadata))
  }
  
  metadata <- metadata |>
    dplyr::arrange(.data$Kategori, .data$Display_navn, .data$Variabel)
  
  dataset_name <- if (is.null(data)) {
    "Alle metadata"
  } else if ("Land" %in% names(data)) {
    "Internasjonale data"
  } else{
    "Norske data"
  }
  
  duplicate_variables <- metadata$Variabel[duplicated(metadata$Variabel) |
                                             duplicated(metadata$Variabel, fromLast = TRUE)]
  
  if (print) {
    cat("\n")
    cat(dataset_name, "\n")
    cat(strrep("-", nchar(dataset_name)), "\n", sep = "")
    cat(nrow(metadata), " variabler\n\n", sep = "")
    
    categories <- unique(metadata$Kategori)
    
    for (category_name in categories) {
      vars <- metadata |>
        dplyr::filter(.data$Kategori == category_name)
      
      cat(category_name, "\n")
      cat(strrep("-", nchar(category_name)), "\n", sep = "")
      
      for (i in seq_len(nrow(vars))) {
        variable_name <- vars$Variabel[i]
        display_name <- vars$Display_navn[i]
        
        label <- if (is.na(display_name) ||
                     display_name == "" ||
                     display_name == variable_name) {
          variable_name
        } else{
          paste0(variable_name, " — ", display_name)
        }
        
        if (variable_name %in% duplicate_variables) {
          label <- paste0(label, " [", vars$Omraade[i], "]")
        }
        
        cat("- ", label, "\n", sep = "")
      }
      
      cat("\n")
    }
  }
  
  invisible(metadata)
}

