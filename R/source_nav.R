
nav_import_excel <- function(url){
  
  tmp <- tempfile(fileext = ".xlsx")
  
  download.file(
    url = url,
    destfile = tmp,
    mode = "wb"
  )
  
  rio::import_list(tmp)
}

