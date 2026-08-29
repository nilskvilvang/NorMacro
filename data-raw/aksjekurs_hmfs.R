
# Historical Norwegian stock price index
#
# Source:
# Norges Bank, Historical Monetary and Financial Statistics (HMFS),
# Stock price indices, Table A1.
#
# Source file:
# https://www.norges-bank.no/en/topics/statistics/Historical-monetary-statistics/
#
# The aggregate "Total" series is used.
# Annual observations are calculated as arithmetic means of the
# available monthly observations.
#
# NorMacro uses the HMFS component through 2000. The incomplete
# year 2001 is excluded. From 2001 onwards, NorMacro uses the
# OECD share price index for Norway.

library(dplyr)
library(readr)
library(readxl)

source_url <- paste0(
  "https://www.norges-bank.no/globalassets/upload/hms/data/",
  "stockprices.xlsx?v=17082017181356"
)

input_file <- tempfile(fileext = ".xlsx")

download.file(
  source_url,
  input_file,
  mode = "wb",
  quiet = TRUE
)

output_file <- "inst/extdata/aksjekurs_hmfs.csv"

stock <- read_excel(
  input_file,
  sheet = "p1c8_table_a1",
  skip = 11
)

aksjekurs_hmfs <- stock |>
  transmute(
    Aar = as.integer(substr(Year, 1, 4)),
    Aksjekursindeks = Total
  ) |>
  filter(
    !is.na(Aksjekursindeks),
    Aar <= 2000
  ) |>
  group_by(Aar) |>
  summarise(
    Aksjekursindeks = mean(Aksjekursindeks),
    .groups = "drop"
  ) |>
  arrange(Aar)

stopifnot(
  min(aksjekurs_hmfs$Aar) == 1914L,
  max(aksjekurs_hmfs$Aar) == 2000L,
  nrow(aksjekurs_hmfs) == 87L,
  !anyNA(aksjekurs_hmfs$Aksjekursindeks)
)

write_delim(
  aksjekurs_hmfs,
  output_file,
  delim = ";"
)
