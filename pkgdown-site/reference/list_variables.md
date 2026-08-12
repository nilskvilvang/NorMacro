# List tilgjengelige variabler

Gir en oversikt over variablene som er tilgjengelige i NorMacro eller i
et angitt datasett. Variablene grupperes etter kategori og vises med
både variabelnavn og beskrivende navn når dette finnes.

## Usage

``` r
list_variables(data = NULL, category = NULL, type = NULL, print = TRUE)
```

## Arguments

- data:

  Et NorMacro-datasett eller \`NULL\`. Dersom \`NULL\`, brukes den
  samlede NorMacro-metadataen.

- category:

  Valgfri kategori som variabellisten skal begrenses til. Standard er
  \`NULL\`, som inkluderer alle kategorier.

- type:

  Valgfri variabeltype som listen skal begrenses til. Standard er
  \`NULL\`, som inkluderer alle typer.

- print:

  Logisk verdi. Dersom \`TRUE\`, skrives en formatert oversikt til
  konsollen. Standard er \`TRUE\`.

## Value

Metadata for variablene som oppfyller kriteriene, returnert usynlig.

## Details

Listen kan avgrenses til en bestemt kategori eller variabeltype.
Funksjonen er særlig nyttig for å utforske hvilke data som finnes før en
analyse.

## Examples

``` r
if (FALSE) { # \dontrun{
list_variables()

# Resultatet kan også lagres uten utskrift
variables <- list_variables(
  print = FALSE
)
} # }
```
