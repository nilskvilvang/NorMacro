
library(readr)
library(dplyr)

metadata <- read_csv("data/metadata.csv", show_col_types = FALSE)

if (!"Display_navn" %in% names(metadata)) {
  
  metadata <- metadata |>
    mutate(
      Display_navn = gsub("_", " ", Variabel),
      .after = Variabel
    )
  
  write_csv(metadata, "data/metadata.csv", na = "")
}
