
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
# system.time({international <- get_international_macro()})


# kostra <- get_kostra_keyfigures(
  #regions = c(
    #"0301",
    #"4601",
    #"5001"
  #),
 # years = 2015:2025
#)