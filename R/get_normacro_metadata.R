
get_normacro_metadata <- function() {
  
  readr::read_csv(
    file.path("data", "metadata.csv"),
    show_col_types = FALSE,
    na = c("", "NA")
  )
}