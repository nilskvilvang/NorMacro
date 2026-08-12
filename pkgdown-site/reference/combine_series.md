# Kombiner norske og internasjonale tidsserier

Bygger et standardisert \`comparison_series\`-objekt fra norske og/eller
internasjonale NorMacro-serier.

## Usage

``` r
combine_series(
  norway = NULL,
  international = NULL,
  start_year = NULL,
  end_year = NULL
)
```

## Arguments

- norway:

  Valgfri tegnvektor med norske NorMacro-variabler.

- international:

  Valgfri navngitt liste med landkoder som navn og internasjonale
  variabler som verdier, for eksempel \`list(SE = c("Inflasjon",
  "BNP_vekst"))\`.

- start_year:

  Valgfritt første år i datasettet.

- end_year:

  Valgfritt siste år i datasettet.

## Value

Et objekt av klassen \`comparison_series\`.

## Details

Resultatet bruker langt format og inneholder informasjon om år, serie,
datasett, land, variabel, visningsnavn, verdi, enhet og kilde.

\`comparison_series\` er utgangspunktet for NorMacros objektbaserte
analyseverktøy, blant annet \[index()\], \[growth()\], \[normalize()\],
\[correlate()\], \[regress()\] og \[autocorrelate()\].

## Examples

``` r
if (FALSE) { # \dontrun{
x <- combine_series(
  norway = c(
    "Inflasjon",
    "BNP_Fastland_vekst"
  ),
  international = list(
    SE = c(
      "Inflasjon",
      "BNP_vekst"
    )
  ),
  start_year = 2000
)
} # }
```
