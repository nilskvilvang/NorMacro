# Estimer regresjonsmodeller for sammenligningsserier

Generisk funksjon for regresjonsanalyse. For et \`comparison_series\`
angis modellen med en vanlig R-formel der variablene er \`Serie_id\`-ene
i objektet.

## Usage

``` r
regress(x, ...)
```

## Arguments

- x:

  Objektet som skal analyseres.

- ...:

  Tilleggsargumenter sendt til metode.

## Value

Et regresjonsresultat. For \`comparison_series\` returneres et objekt av
klassen \`comparison_series_regression\`.

## See also

\[combine_series()\], \[correlate()\], \[autocorrelate()\]
