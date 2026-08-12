# Vis en oversikt over NorMacro-data

\`overview()\` viser en samlet oversikt over NorMacro-databasene.

## Usage

``` r
overview(data = NULL, print = TRUE)
```

## Arguments

- data:

  Et NorMacro-datasett. Hvis \`NULL\`, vises en samlet oversikt over
  norske og internasjonale data.

- print:

  Logisk. Hvis \`TRUE\`, skrives oversikten til konsollen.

## Value

En liste med informasjon om datasettet, usynlig.

## Details

Når et datasett oppgis, identifiserer funksjonen automatisk om det er:

\- norske makrodata - internasjonale makrodata - KOSTRA-data

## Examples

``` r
if (FALSE) { # \dontrun{
overview()

normacro <- get_normacro()
overview(normacro)

international <- get_international_macro()
overview(international)

kostra <- get_kostra_financial_foundations(
  regions = "0301",
  concepts = c("AGD23", "KG31"),
  years = 2020:2024
)

overview(kostra)
} # }
```
