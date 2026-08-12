# Beskriv en variabel i NorMacro

Viser metadata for én variabel, blant annet beskrivelse, kilde, enhet,
frekvens, dekningsperiode, tilhørende funksjon og eventuell tabell- og
kommentarinformasjon.

## Usage

``` r
describe_variable(variable, print = TRUE)
```

## Arguments

- variable:

  Navnet på variabelen som skal beskrives.

- print:

  Logisk verdi. Dersom \`TRUE\`, skrives en lesbar metadataoversikt til
  konsollen. Standard er \`TRUE\`.

## Value

Metadata for den valgte variabelen, returnert usynlig.

## Details

Funksjonen er nyttig når du har funnet en variabel og ønsker å forstå
hva den måler og hvor dataene kommer fra før variabelen brukes i en
analyse.

## Examples

``` r
if (FALSE) { # \dontrun{
describe_variable("BNP_Fastland")
} # }
```
