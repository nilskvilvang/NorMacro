# Forklar konjunkturklassifisering for ett år

Viser konjunkturfase, samlet score, delkomponenter og underliggende
indikatorverdier for ett valgt år.

## Usage

``` r
business_cycle_explain(year, data = NULL, ...)
```

## Arguments

- year:

  Året som skal forklares.

- data:

  Valgfritt NorMacro-datasett. Hvis \`NULL\`, brukes standarddatasettet.

- ...:

  Videre argumenter sendt til \[business_cycle()\].

## Value

Resultatet for valgt år returneres usynlig som en tibble.

## Examples

``` r
if (FALSE) { # \dontrun{
business_cycle_explain(
  2020
)
} # }
```
