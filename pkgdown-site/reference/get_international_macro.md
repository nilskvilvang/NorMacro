# Hent internasjonale makrodata

Henter NorMacros standardiserte internasjonale makrodatasett.

## Usage

``` r
get_international_macro(export = FALSE, refresh = FALSE)
```

## Arguments

- export:

  Logisk. Om datasettet også skal eksporteres til fil.

- refresh:

  Logisk. Om eksisterende cache skal fornyes.

## Value

En tibble med internasjonale makroøkonomiske tidsserier.

## Details

Datasettet inneholder årlige makroøkonomiske indikatorer for Norge og
utvalgte europeiske land i et felles format med kolonnene \`Aar\` og
\`Land\`.

## Examples

``` r
if (FALSE) { # \dontrun{
international <- get_international_macro()
} # }
```
