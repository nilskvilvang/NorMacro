# Beregn vekst eller endring i sammenligningsserier

Beregner prosentvis vekst eller absolutt endring separat for hver serie
i et \`comparison_series\`-objekt.

## Usage

``` r
# S3 method for class 'comparison_series'
growth(x, periods = 1, percent = TRUE, ...)
```

## Arguments

- x:

  Et \`comparison_series\`-objekt.

- periods:

  Antall perioder som skal brukes i vekst- eller endringsberegningen. Må
  være et positivt heltall.

- percent:

  Logisk. Hvis \`TRUE\`, beregnes prosentvis vekst. Hvis \`FALSE\`,
  beregnes absolutt endring.

- ...:

  Videre argumenter til metoden.

## Value

Et \`comparison_series\`-objekt med transformasjonen \`growth_percent\`
eller \`growth_absolute\`.

## Details

Resultatet beholder \`comparison_series\`-klassen og får metadata som
beskriver transformasjonen og antall perioder.
