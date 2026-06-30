describe_variable <- function(variable){
  
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(Variabel == variable)
  
  if(nrow(result) == 0){
    stop("Fant ikke variabelen i metadata: ", variable)
  }
  
  result
}