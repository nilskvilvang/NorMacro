
get_display_name <- function(variable, metadata = NULL){
  
  if(is.null(metadata)){
    metadata <- get_metadata()
  }
  
  idx <- match(variable, metadata$Variabel)
  
  name <- ifelse(
    is.na(idx),
    NA_character_,
    metadata$Display_navn[idx]
  )
  
  ifelse(
    is.na(name) | name == "",
    variable,
    name
  )
}
