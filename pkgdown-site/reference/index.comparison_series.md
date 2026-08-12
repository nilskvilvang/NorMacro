# Indekser sammenligningsserier

Omgjør et \`comparison_series\`-objekt på opprinnelig nivå til
indeksserier med et felles basisår og en felles basisverdi.

## Usage

``` r
# S3 method for class 'comparison_series'
index(x, base_year = NULL, base_value = 100, ...)
```

## Arguments

- x:

  Et \`comparison_series\`-objekt.

- base_year:

  Valgfritt basisår. Hvis \`NULL\`, brukes første felles år med
  observasjoner for alle seriene.

- base_value:

  Numerisk basisverdi. Standard er 100.

- ...:

  Videre argumenter til metoden.

## Value

Et \`comparison_series\`-objekt der seriene er omregnet til indeks med
valgt basisår og basisverdi.

## Details

Hvis \`base_year\` ikke oppgis, brukes første år der alle seriene har
tilgjengelige observasjoner.

\`index()\` kan bare brukes på serier som fortsatt er på opprinnelig
nivå. Den kan derfor ikke brukes på objekter som allerede er indeksert
eller på annen måte transformert.
