# Vis datadekning for variabler

Beregner hvilken periode hver variabel i et datasett dekker, hvor mange
observasjoner som finnes, og hvor mange verdier som mangler.

## Usage

``` r
coverage(data = NULL)
```

## Arguments

- data:

  Et datasett med kolonnen \`Aar\`. Dersom \`NULL\`, hentes NorMacros
  standarddatasett med \[get_normacro()\].

## Value

En tibble med én rad per variabel. Resultatet inneholder blant annet
\`Variabel\`, \`Startaar_data\`, \`Sluttaar_data\`,
\`Antall_observasjoner\` og \`Antall_mangler\`. Når metadata finnes,
inkluderes også tilgjengelig variabelmetadata.

## Details

Funksjonen er nyttig før en analyse for å undersøke hvor langt tilbake
tidsseriene går og om variablene har manglende observasjoner. Dersom
metadata er tilgjengelig, legges relevant variabelinformasjon til
resultatet.

Hvis \`data = NULL\`, brukes NorMacros standarddatasett.

## Examples

``` r
if (FALSE) { # \dontrun{
coverage()

data <- get_normacro()
coverage(data)
} # }
```
