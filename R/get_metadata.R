
get_metadata <- function(){
  
  path <- "data/metadata.csv"
  
  if(!file.exists(path)){
    path <- file.path("..", "..", "data", "metadata.csv")
  }
  
  readr::read_csv(
    path,
    show_col_types = FALSE
  )
}