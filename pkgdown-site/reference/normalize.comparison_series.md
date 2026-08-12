# Normaliser sammenligningsserier

Normaliserer seriene i et \`comparison_series\`-objekt til indeks 100 i
et felles basisår.

## Usage

``` r
# S3 method for class 'comparison_series'
normalize(x, base_year = NULL, ...)
```

## Arguments

- x:

  Et \`comparison_series\`-objekt.

- base_year:

  Valgfritt basisår. Hvis \`NULL\`, brukes første felles år med gyldige
  observasjoner for alle seriene.

- ...:

  Videre argumenter til metoden.

## Value

Et indeksert \`comparison_series\`-objekt med basisverdi 100.

## Details

Metoden er en snarvei til \`index(x, base_year = ..., base_value =
100)\`.
