
set_kostra_attributes <- function(data, config) {
  attr(data, "dataset_type") <- "kostra"
  attr(data, "kostra_table") <- config$table
  attr(data, "kostra_title") <- config$title
  data
}
