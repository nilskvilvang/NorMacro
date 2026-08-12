# Hent NorMacro-datasettet

Bygger og returnerer NorMacros standardiserte makroøkonomiske datasett.
Datasettet valideres før det returneres.

## Usage

``` r
get_normacro(export = FALSE)
```

## Arguments

- export:

  Logisk verdi. Dersom \`TRUE\`, eksporteres NorMacro-datasettet til
  \`data_clean/normacro.csv\` og \`data_clean/normacro.rds\`, og
  metadata eksporteres til \`data_clean/metadata_normacro.csv\` og
  \`data_clean/metadata_normacro.xlsx\`. Standard er \`FALSE\`.

## Value

Et standardisert og validert NorMacro-datasett.

## Details

Dersom \`export = TRUE\`, lagres datasettet og tilhørende metadata i
mappen \`data_clean\`.

## Examples

``` r
if (FALSE) { # \dontrun{
data <- get_normacro()

# Hent data og lagre datasett og metadata lokalt
data <- get_normacro(
  export = TRUE
)
} # }
```
