
cache_get <- function(name, fun, refresh = FALSE){
  
  dir.create("cache", showWarnings = FALSE)
  
  file <- file.path("cache", paste0(name, ".rds"))
  
  if(file.exists(file) && !refresh){
    message("Leser cache: ", name)
    return(readRDS(file))
  }
  
  message("Laster ned: ", name)
  
  data <- fun()
  
  saveRDS(data, file)
  
  data
}