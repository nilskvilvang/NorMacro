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
library(eurostat)



# pxweb::pxweb_interactive("data.ssb.no")

# sjekksekvens
## rm(list = ls())
## source("source_all.R")
## normacro <- get_normacro()
## international <- get_international_macro()
## tail(normacro)

## validate_metadata()
## testthat::test_dir("tests/testthat")


# git add .
# git commit -m "Added household and public consumption indicators"
# git push

# Når man vet github har rett versjon, men ikke får tatt git pull lokalt:
# git fetch origin
# git reset --hard origin/main
# Dette sletter alle lokale endringer som ikke er pushet fra den lokale maskinen

# Test tid det tar å kjøre funksjon
# system.time({
# international <- get_international_macro()
# })


retry_download <- function(expr, retries = 5, wait = 5, label = "Nedlasting") {
  for (i in seq_len(retries)) {
    result <- tryCatch(
      force(expr),
      error = function(e) e
    )
    
    if (!inherits(result, "error")) {
      return(result)
    }
    
    if (i < retries) {
      msg <- sprintf("%s feilet. Prøver igjen om %s sekunder (forsøk %s av %s).", label, wait, i + 1, retries)
      message(msg)
      Sys.sleep(wait)
    } else {
      stop(conditionMessage(result), call. = FALSE)
    }
  }
}




