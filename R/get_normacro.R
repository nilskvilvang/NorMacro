
get_normacro <- function(
    export = FALSE
) {
  
  normacro <- build_database()
  
  check_normacro(normacro)
  
  if (export) {
    dir.create(
      "data_clean",
      showWarnings = FALSE
    )
    
    rio::export(
      normacro,
      "data_clean/normacro.csv"
    )
    
    rio::export(
      normacro,
      "data_clean/normacro.rds"
    )
    
    metadata <- get_normacro_metadata()
    
    rio::export(
      metadata,
      "data_clean/metadata_normacro.csv"
    )
    
    rio::export(
      metadata,
      "data_clean/metadata_normacro.xlsx"
    )
  }
  
  normacro
}
