# Estimer regresjonsmodell for sammenligningsserier

Estimerer en regresjonsmodell basert på seriene i et
\`comparison_series\`-objekt.

## Usage

``` r
# S3 method for class 'comparison_series'
regress(x, formula, model = "ols", start_year = NULL, end_year = NULL, ...)
```

## Arguments

- x:

  Et \`comparison_series\`-objekt.

- formula:

  En R-formel, for eksempel \`NO_BNP_Fastland_vekst ~ NO_Inflasjon +
  SE_BNP_vekst\`.

- model:

  Modelltype. Standard er \`"ols"\`.

- start_year:

  Valgfritt første år i estimeringsperioden.

- end_year:

  Valgfritt siste år i estimeringsperioden.

- ...:

  Videre argumenter til metoden.

## Value

Et objekt av klassen \`comparison_series_regression\`.

## Details

Modellen angis med en vanlig R-formel der variablene er \`Serie_id\`-ene
i objektet.
