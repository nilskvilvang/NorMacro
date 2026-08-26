
# Source:
# Norges Bank, Historical Monetary and Financial Statistics,
# Bond yields, Table A3 Annual.
#
# ST10 = Norwegian government bond yield, 10-year maturity.
#
# NorMacro uses 1921–1984. From 1985 onwards the composite
# Statsrente_10aar series uses OECD and later Norges Bank.

library(dplyr)
library(readxl)
library(readr)
library(lubridate)

source_file <- "bond_yields.xlsx"

a3 <- read_excel(source_file, sheet = "p1_c4_table_A3_Annual", skip = 17)

hmfs_statsrente <- a3 |>
  transmute(Aar = year(Year), Statsrente_10aar = as.numeric(ST10)) |>
  filter(Aar >= 1921, Aar <= 1984, !is.na(Statsrente_10aar)) |>
  arrange(Aar)

stopifnot(
  nrow(hmfs_statsrente) == 64L,
  identical(hmfs_statsrente$Aar, 1921:1984),!anyNA(hmfs_statsrente$Statsrente_10aar)
)

write_csv(hmfs_statsrente, "inst/extdata/statsrente_hmfs.csv")
