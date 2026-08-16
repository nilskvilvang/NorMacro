# Lag scatterplott mellom to tidsserier

Visualiserer sammenhengen mellom to variabler i et NorMacro-datasett.
Figuren kan avgrenses til en bestemt periode og kan inkludere en
utjevnet trendlinje.

## Usage

``` r
scatter_series(
  x,
  y,
  data = NULL,
  start_year = NULL,
  end_year = NULL,
  add_smooth = TRUE,
  label_years = FALSE,
  country = NULL,
  unit = NULL
)
```

## Arguments

- x:

  Navnet på variabelen på x-aksen.

- y:

  Navnet på variabelen på y-aksen.

- data:

  Valgfritt NorMacro-datasett.

- start_year:

  Valgfritt første år i analyseperioden.

- end_year:

  Valgfritt siste år i analyseperioden.

- add_smooth:

  Logisk. Om en utjevnet trendlinje skal legges til.

- label_years:

  Logisk. Om observasjonene skal merkes med år.

- country:

  Valgfritt land når \`data\` inneholder internasjonale data.

- unit:

  Valgfri KOSTRA-enhet når \`data\` inneholder flere enheter.

## Value

Et \`ggplot\`-objekt.

## Details

Funksjonen støtter norske makrodata, internasjonale data og KOSTRA-data.

## Examples

``` r
scatter_series(
  x = "BNP_Fastland_vekst",
  y = "Arbeidsledighetsrate_NAV",
  data = normacro_example
)

```
