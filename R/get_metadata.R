
get_metadata <- function(){
  
  path <- "data/metadata.csv"
  
  if(!file.exists(path)){
    path <- file.path("..", "..", "data", "metadata.csv")
  }
  
  metadata <- readr::read_csv(
    path,
    locale = readr::locale(encoding = "UTF-8"),
    show_col_types = FALSE
  )
  
  fix_text <- function(x){
    if(!is.character(x)) return(x)
    
    x |>
      stringr::str_replace_all(stringr::fixed("C\u0005"), "Å") |>
      stringr::str_replace_all(stringr::fixed("\u00f8"), "ø") |>
      stringr::str_replace_all(stringr::fixed("C8"), "ø") |>
      stringr::str_replace_all(stringr::fixed("C%"), "å")
  }
  
  metadata |>
    dplyr::mutate(
      dplyr::across(
        where(is.character),
        fix_text
      )
    )
}