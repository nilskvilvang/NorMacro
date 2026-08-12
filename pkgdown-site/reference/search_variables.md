# Søk etter variabler

Søker i NorMacros metadata etter variabler som matcher et tekstuttrykk.
Søket omfatter variabelnavn, visningsnavn, beskrivelse, kommentar og
kategori.

## Usage

``` r
search_variables(query, ignore_case = TRUE)
```

## Arguments

- query:

  Tekst eller regulært uttrykk det skal søkes etter.

- ignore_case:

  Logisk verdi som angir om store og små bokstaver skal behandles likt.
  Standard er \`TRUE\`.

## Value

En tibble med variabler som matcher søket og relevant metadata, blant
annet visningsnavn, kategori, beskrivelse, enhet, frekvens,
dekningsperiode, kilde og område.

## Details

Funksjonen gjør det mulig å finne relevante data uten å kjenne de
eksakte NorMacro-variabelnavnene på forhånd.

## Examples

``` r
if (FALSE) { # \dontrun{
search_variables("arbeidsledighet")
search_variables("BNP")
} # }
```
