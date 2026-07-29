
kostra_accounts_12858 <- function() {
  
  config <- kostra_table_12858()
  
  get_kostra_dimension_metadata(
    url = config$url,
    code = config$concept_code
  )
  
}

