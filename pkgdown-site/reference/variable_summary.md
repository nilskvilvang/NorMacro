# Oppsummer en økonomisk variabel

Lager en samlet oppsummering av én variabel med metadata, datadekning,
siste observasjon og relevante statistiske analyser.

## Usage

``` r
variable_summary(
  variable,
  data = NULL,
  country = NULL,
  unit = NULL,
  metadata = NULL,
  correlation_variables = NULL,
  top_n_correlations = 5
)
```

## Arguments

- variable:

  Navnet på variabelen som skal oppsummeres.

- data:

  Et datasett eller \`NULL\`. Dersom \`NULL\`, brukes NorMacros
  standarddatasett når \`country\` ikke er angitt, og internasjonale
  makrodata når \`country\` er angitt.

- country:

  Valgfri landkode for internasjonale data. Må angi ett land dersom
  datasettet inneholder flere land.

- unit:

  Valgfri KOSTRA-enhet. Må angi én enhet dersom KOSTRA-datasettet
  inneholder flere enheter.

- metadata:

  Valgfritt metadata-datasett. Dersom \`NULL\`, hentes metadata fra
  \`data\`.

- correlation_variables:

  Valgfri tegnvektor med variabler som skal brukes i
  korrelasjonsanalysen. Dersom \`NULL\`, vurderes øvrige numeriske
  variabler i datasettet.

- top_n_correlations:

  Positivt heltall som angir hvor mange av de sterkeste korrelasjonene
  som skal vises. Standard er \`5\`.

## Value

En liste returnert usynlig med elementene \`metadata\`, \`coverage\`,
\`latest\`, \`growth\`, \`rate_summary\`, \`correlations\`, \`country\`,
\`kostra_unit\`, \`kostra_unit_name\`, \`kostra_table\` og
\`kostra_title\`. Funksjonen skriver samtidig en formatert oppsummering
til konsollen.

## Details

Innholdet tilpasses variabelens analysetype. For nivå- og
indeksvariabler vises blant annet vekst over ulike perioder. For
ratevariabler vises en statistisk oppsummering. Funksjonen kan også
beregne de sterkeste korrelasjonene mot andre numeriske variabler.

\`variable_summary()\` kan brukes med norske makrodata, internasjonale
data og KOSTRA-data. Internasjonale datasett med flere land krever at
ett land velges med \`country\`. KOSTRA-datasett med flere enheter
krever tilsvarende at én enhet velges med \`unit\`.

## Examples

``` r
if (FALSE) { # \dontrun{
variable_summary("BNP_Fastland")

# Begrens korrelasjonsanalysen til utvalgte variabler
variable_summary(
  variable = "BNP_Fastland",
  correlation_variables = c(
    "Privat_konsum",
    "Fastlandsinvesteringer"
  )
)
} # }
```
