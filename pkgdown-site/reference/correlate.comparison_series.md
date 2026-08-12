# Beregn korrelasjoner mellom sammenligningsserier

Beregner parvise korrelasjoner mellom seriene i et
\`comparison_series\`-objekt.

## Usage

``` r
# S3 method for class 'comparison_series'
correlate(
  x,
  method = c("pearson", "spearman", "kendall"),
  start_year = NULL,
  end_year = NULL,
  include_diagonal = FALSE,
  format = TRUE,
  ...
)
```

## Arguments

- x:

  Et \`comparison_series\`-objekt.

- method:

  Korrelasjonsmetode: \`"pearson"\`, \`"spearman"\` eller \`"kendall"\`.

- start_year:

  Valgfritt første år i analyseperioden.

- end_year:

  Valgfritt siste år i analyseperioden.

- include_diagonal:

  Logisk. Om korrelasjonen mellom hver serie og seg selv skal
  inkluderes.

- format:

  Logisk. Om resultatet skal formateres for utskrift.

- ...:

  Videre argumenter til metoden.

## Value

Et objekt av klassen \`comparison_series_correlation\`.
