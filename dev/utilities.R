
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


# kostra_large <- get_kostra_keyfigures(
#   regions = c(
#     "0301", # Oslo
#     "1103", # Stavanger
#     "1108", # Sandnes
#     "1506", # Molde
#     "1507", # Ålesund
#     "1804", # Bodø
#     "1902", # Tromsø
#     "3103", # Moss
#     "3105", # Sarpsborg
#     "3107", # Fredrikstad
#     "3201", # Bærum
#     "3203", # Asker
#     "3205", # Lillestrøm
#     "3301", # Drammen
#     "3403", # Hamar
#     "3905", # Tønsberg
#     "4001", # Porsgrunn
#     "4204", # Kristiansand
#     "4601", # Bergen
#     "5001"  # Trondheim
#   ),
#   years = 2015:2025
# )


## For å kjøre tests uten live pga timinig:

# Sys.setenv(
#   NORMACRO_RUN_LIVE_TESTS = "true"
# )
# 
# devtools::test()

## Deretter

# Sys.unsetenv(
#   "NORMACRO_RUN_LIVE_TESTS"
# )

## load test for alle
# devtools::test()

## Build-check
# devtools::check()

## SJekke vignetter
# browseVignettes("NorMacro")
