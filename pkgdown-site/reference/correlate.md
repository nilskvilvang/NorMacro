# Beregn korrelasjoner mellom sammenligningsserier

Generisk funksjon for korrelasjonsanalyse. For et \`comparison_series\`
beregnes parvise korrelasjoner mellom seriene.

## Usage

``` r
correlate(x, ...)
```

## Arguments

- x:

  Objektet som skal analyseres.

- ...:

  Tilleggsargumenter sendt til metode.

## Value

Et korrelasjonsresultat. For \`comparison_series\` returneres et objekt
av klassen \`comparison_series_correlation\`.

## See also

\[combine_series()\], \[regress()\], \[autocorrelate()\]
