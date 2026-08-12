# Klassifiser konjunkturfase

Klassifiserer hvert år i en konjunkturfase basert på en samlet score fra
NorMacros konjunkturindikatorer.

## Usage

``` r
business_cycle(
  data = NULL,
  recession_max = -8,
  slowdown_max = -2,
  boom_min = 6,
  ...
)
```

## Arguments

- data:

  Valgfritt NorMacro-datasett. Hvis \`NULL\`, brukes standarddatasettet.

- recession_max:

  Øvre grense for klassifisering som \`"Nedgang"\`.

- slowdown_max:

  Øvre grense for klassifisering som \`"Svak vekst"\`.

- boom_min:

  Nedre grense for klassifisering som \`"Høykonjunktur"\`.

- ...:

  Videre argumenter sendt til den underliggende konjunkturscoringen.

## Value

En tibble med år, konjunkturfase, samlet score, antall indikatorer og
underliggende delkomponenter.

## Details

Klassifiseringen bruker terskler for nedgang, svak vekst, ekspansjon og
høykonjunktur.

## Examples

``` r
cycle <- business_cycle(
  data = normacro_example
)
#> Error in business_cycle_score(data = data, ...): Fant ikke nødvendige variabler i datasettet: Konjunkturindikator, Kapasitetsutnytting, Rentekurve
```
