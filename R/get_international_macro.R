

get_international_macro <- function(export = FALSE) {
  international <- build_international_database()
  
  check_metadata(international)
  
  if (export) {
    dir.create("data_clean", showWarnings = FALSE)
    
    rio::export(international, "data_clean/international.csv")
    
    rio::export(international, "data_clean/international.rds")
    
    metadata <- get_international_metadata()
    
    rio::export(metadata, "data_clean/metadata_international.csv")
    
    rio::export(metadata, "data_clean/metadata_international.xlsx")
  }
  
  international
}
