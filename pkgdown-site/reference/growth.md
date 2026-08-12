# Beregn vekst eller endring i sammenligningsserier

Generisk funksjon for å beregne vekst eller absolutt endring i et
objekt. For \`comparison_series\` utføres transformasjonen separat for
hver serie.

## Usage

``` r
growth(x, ...)
```

## Arguments

- x:

  Objektet som skal transformeres.

- ...:

  Tilleggsargumenter sendt til metode.

## Value

Et transformert objekt. For \`comparison_series\` returneres et nytt
\`comparison_series\`-objekt.

## See also

\[combine_series()\], \[index()\], \[normalize()\]
