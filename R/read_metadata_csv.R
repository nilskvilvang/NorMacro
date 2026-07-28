
read_metadata_csv <- function(filename) {
  
  path <-
    system.file(
      "extdata",
      filename,
      package = "NorMacro"
    )
  
  if (!nzchar(path)) {
    stop(
      "Fant ikke filen: ",
      filename,
      call. = FALSE
    )
  }
  
  readr::read_delim(
    path,
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