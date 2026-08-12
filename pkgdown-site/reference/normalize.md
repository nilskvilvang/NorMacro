# Normaliser sammenligningsserier

Generisk funksjon for normalisering av serier. For \`comparison_series\`
tilsvarer normalisering indeksering til 100 i et felles basisår.

## Usage

``` r
normalize(x, ...)
```

## Arguments

- x:

  Objektet som skal normaliseres.

- ...:

  Tilleggsargumenter sendt til metode.

## Value

Et normalisert objekt. For \`comparison_series\` returneres et indeksert
\`comparison_series\`-objekt med basisverdi 100.

## See also

\[combine_series()\], \[index()\], \[growth()\]
