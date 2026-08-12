# Beregn autokorrelasjon i sammenligningsserier

Beregner autokorrelasjon separat for hver serie i et
\`comparison_series\`-objekt for ett eller flere lag.

## Usage

``` r
# S3 method for class 'comparison_series'
autocorrelate(
  x,
  lags = 1:5,
  start_year = NULL,
  end_year = NULL,
  use = c("pairwise.complete.obs", "complete.obs", "everything", "all.obs",
    "na.or.complete"),
  method = c("pearson", "spearman", "kendall"),
  format = TRUE,
  ...
)
```

## Arguments

- x:

  Et \`comparison_series\`-objekt.

- lags:

  Positive heltall som angir hvilke lag som skal beregnes.

- start_year:

  Valgfritt første år i analyseperioden.

- end_year:

  Valgfritt siste år i analyseperioden.

- use:

  Regel for håndtering av manglende observasjoner. Samme valg som i
  \`stats::cor()\`.

- method:

  Korrelasjonsmetode: \`"pearson"\`, \`"spearman"\` eller \`"kendall"\`.

- format:

  Logisk. Om resultatet skal formateres for utskrift.

- ...:

  Videre argumenter til metoden.

## Value

Et objekt av klassen \`comparison_series_autocorrelation\`.
