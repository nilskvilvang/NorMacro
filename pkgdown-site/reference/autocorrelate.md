# Beregn autokorrelasjon i sammenligningsserier

Generisk funksjon for autokorrelasjonsanalyse. For et
\`comparison_series\` beregnes autokorrelasjon separat for hver serie og
de valgte lagene.

## Usage

``` r
autocorrelate(x, ...)
```

## Arguments

- x:

  Objektet som skal analyseres.

- ...:

  Tilleggsargumenter sendt til metode.

## Value

Et autokorrelasjonsresultat. For \`comparison_series\` returneres et
objekt av klassen \`comparison_series_autocorrelation\`.

## See also

\[combine_series()\], \[correlate()\], \[regress()\]
