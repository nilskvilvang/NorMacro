library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(stringr)
library(purrr)
library(tibble)
library(scales)
library(rio)
library(pxweb)
library(PxWebApiData)
library(janitor)
library(lubridate)
library(quantmod)
library(testthat)



# pxweb::pxweb_interactive("data.ssb.no")

# sjekksekvens
## rm(list = ls())
## source("source_all.R")
## normacro <- get_normacro()
## tail(normacro)

## validate_metadata()
## testthat::test_dir("tests/testthat")


# git add .
# git commit -m "Added household and public consumption indicators"
# git push


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