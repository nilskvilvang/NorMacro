# Sammenlign tidsserier

Sammenligner flere tidsserier i et felles datasett. Seriene kan
normaliseres til en felles skala, slik at utviklingen kan sammenlignes
selv når variablene har forskjellige måleenheter.

## Usage

``` r
compare_series(
  variables,
  data = NULL,
  country = NULL,
  unit = NULL,
  base_year = NULL,
  normalize = TRUE,
  start_year = NULL,
  complete_cases = FALSE
)
```

## Arguments

- variables:

  En tegnvektor med variabler som skal sammenlignes.

- data:

  Datasett som inneholder \`Aar\` og de valgte variablene. Hvis
  \`NULL\`, brukes NorMacros standarddata.

- country:

  Valgfritt land ved analyse av internasjonale data.

- unit:

  Valgfri måleenhet.

- base_year:

  Valgfritt basisår ved normalisering.

- normalize:

  Logisk. Hvis \`TRUE\`, normaliseres seriene før sammenligning.

- start_year:

  Valgfritt første år i sammenligningen.

- complete_cases:

  Logisk. Hvis \`TRUE\`, brukes bare år med komplette observasjoner for
  alle valgte variabler.

## Value

Et objekt som representerer de sammenlignede tidsseriene.

## Examples

``` r
compare_series(
  c("Inflasjon", "Styringsrente"),
  data = normacro_example
)

```
