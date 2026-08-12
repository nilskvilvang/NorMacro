# Hent utvalgte KOSTRA-nøkkeltall

Henter og standardiserer utvalgte kommunale nøkkeltall fra KOSTRA-tabell
12134.

## Usage

``` r
get_kostra_keyfigures(regions, years = 2015:2025)
```

## Arguments

- regions:

  En tegnvektor med KOSTRA-koder for kommuner eller andre støttede
  enheter.

- years:

  År som skal hentes. Standard er 2015 til 2025.

## Value

En tibble med standardiserte KOSTRA-nøkkeltall.

## Details

Resultatet returneres i NorMacros standardiserte KOSTRA-format med
kolonnene \`Enhet\`, \`Enhet_navn\`, \`Enhetstype\` og \`Aar\`, i
tillegg til indikatorene i tabellen.

## Examples

``` r
if (FALSE) { # \dontrun{
kostra <- get_kostra_keyfigures(
  regions = c("0301", "4601"),
  years = 2020:2025
)
} # }
```
