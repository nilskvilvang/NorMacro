
get_international_metadata <- function() {
  
  readr::read_csv(
    file.path("data", "metadata_international.csv"),
    show_col_types = FALSE,
    na = c("", "NA")
  )
}
