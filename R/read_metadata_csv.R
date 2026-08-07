
read_metadata_csv <- function(filename) {
  
  # 1. Installert pakke eller devtools::load_all()
  path <- system.file(
    "extdata",
    filename,
    package = "NorMacro"
  )
  
  # 2. Kjøring direkte fra kildekode:
  #    finn prosjektroten ved å gå oppover til DESCRIPTION finnes.
  if (!nzchar(path)) {
    
    current_dir <- normalizePath(
      getwd(),
      winslash = "/",
      mustWork = TRUE
    )
    
    repeat {
      
      description_file <- file.path(
        current_dir,
        "DESCRIPTION"
      )
      
      source_path <- file.path(
        current_dir,
        "inst",
        "extdata",
        filename
      )
      
      if (
        file.exists(description_file) &&
        file.exists(source_path)
      ) {
        path <- source_path
        break
      }
      
      parent_dir <- dirname(current_dir)
      
      if (identical(parent_dir, current_dir)) {
        break
      }
      
      current_dir <- parent_dir
    }
  }
  
  if (!nzchar(path) || !file.exists(path)) {
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