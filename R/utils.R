library(tidyverse)
library(rio)
library(pxweb)
library(PxWebApiData)
library(janitor)
library(lubridate)
library(quantmod)

# pxweb::pxweb_interactive("data.ssb.no")

# sjekksekvens
## rm(list = ls())
## source("source_all.R")
## normacro <- build_database()
## check_metadata(normacro)
## tail(normacro)


check_metadata <- function(data, metadata = NULL, ignore = "Aar"){
  
  if(is.null(metadata)){
    metadata <- get_metadata()
  }
  
  missing_vars <- setdiff(
    names(data),
    c(metadata$Variabel, ignore)
  )
  
  if(length(missing_vars) == 0){
    message("✓ Alle variabler er dokumentert i metadata.")
  } else {
    warning(
      paste(
        "Variabler uten metadata:",
        paste(missing_vars, collapse = ", ")
      )
    )
  }
  
  invisible(missing_vars)
}