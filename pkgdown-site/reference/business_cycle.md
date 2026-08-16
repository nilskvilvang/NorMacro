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
if (FALSE) { # \dontrun{
cycle <- business_cycle()
} # }
```
