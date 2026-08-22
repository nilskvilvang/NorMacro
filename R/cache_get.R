
cache_get <- function(
    name,
    fun,
    refresh = FALSE,
    verbose = FALSE
) {
  
  cache_dir <- tools::R_user_dir(
    package = "NorMacro",
    which = "cache"
  )
  
  dir.create(
    cache_dir,
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  file <- file.path(
    cache_dir,
    paste0(name, ".rds")
  )
  
  if (file.exists(file) && !refresh) {
    if (verbose) {
      message("Leser cache: ", name)
    }
    
    cached <- tryCatch(
      readRDS(file),
      error = function(e) NULL
    )
    
    if (!is.null(cached)) {
      return(cached)
    }
    
    if (verbose) {
      message(
        "Kunne ikke lese cache. Laster ned p\u00e5 nytt: ",
        name
      )
    }
  }
  
  if (verbose) {
    message("Laster ned: ", name)
  }
  
  data <- fun()
  
  saveRDS(
    data,
    file
  )
  
  data
}