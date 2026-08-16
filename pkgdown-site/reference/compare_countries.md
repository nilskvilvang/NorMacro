# Sammenlign en variabel mellom land

Lager et tidsserieplott for en internasjonal makrovariabel paa tvers av
valgte land.

## Usage

``` r
compare_countries(
  variable,
  countries = NULL,
  data = NULL,
  start_year = NULL,
  normalize = FALSE,
  base_year = NULL
)
```

## Arguments

- variable:

  Navn paa en variabel i det internasjonale datasettet.

- countries:

  Tegnvektor med landkoder som skal sammenlignes. Hvis \`NULL\`, brukes
  tilgjengelige standardland.

- data:

  Internasjonalt NorMacro-datasett. Hvis \`NULL\`, brukes
  \[get_international_macro()\].

- start_year:

  Forste aar som skal vises. Standard er \`NULL\`.

- normalize:

  Logisk. Hvis \`TRUE\`, normaliseres seriene til 100 i et felles
  basisaar.

- base_year:

  Basisaar ved normalisering. Hvis \`NULL\`, brukes forste felles aar
  med data for alle valgte land.

## Value

Et \`ggplot\`-objekt.

## Examples

``` r
if (FALSE) { # \dontrun{
compare_countries(
  "BNP_vekst",
  countries = c("NO", "SE", "DK", "DE")
)

compare_countries(
  "Arbeidsproduktivitet",
  countries = c("NO", "SE", "DK", "DE"),
  start_year = 2000,
  normalize = TRUE
)
} # }
```
