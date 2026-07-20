
get_international_metadata <- function() {
  readr::read_delim(
    file.path("data", "metadata_international.csv"),
    delim = ";",
    locale = readr::locale(
      decimal_mark = ",",
      grouping_mark = ".",
      encoding = "UTF-8"
    ),
    show_col_types = FALSE,
    na = c("", "NA"),
    trim_ws = TRUE
  )
}
