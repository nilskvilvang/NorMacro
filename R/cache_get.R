

cache_get <- function(name,
                      fun,
                      refresh = FALSE,
                      verbose = FALSE) {
  dir.create("cache", recursive = TRUE, showWarnings = FALSE)
  
  file <- file.path("cache", paste0(name, ".rds"))
  
  if (file.exists(file) && !refresh) {
    if (verbose) {
      message("Leser cache: ", name)
    }
    
    cached <- tryCatch(
      readRDS(file),
      error = function(e)
        NULL
    )
    
    if (!is.null(cached)) {
      return(cached)
    }
    
    if (verbose) {
      message("Kunne ikke lese cache. Laster ned på nytt: ", name)
    }
  }
  
  if (verbose) {
    message("Laster ned: ", name)
  }
  
  data <- fun()
  
  saveRDS(data, file)
  
  data
}
