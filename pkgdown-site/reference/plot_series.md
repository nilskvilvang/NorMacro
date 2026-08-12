# Plot en tidsserie

Lager en tidsseriefigur for en variabel i et NorMacro-datasett.
Funksjonen bruker metadata til å sette tittel, beskrivelse, måleenhet og
kilde når denne informasjonen er tilgjengelig.

## Usage

``` r
plot_series(variable, data = NULL, metadata = NULL, countries = NULL)
```

## Arguments

- variable:

  Navnet på variabelen som skal plottes.

- data:

  Datasett som inneholder \`Aar\` og variabelen som skal plottes. Hvis
  \`NULL\`, hentes standarddatasettet med \[get_normacro()\].

- metadata:

  Metadata for datasettet. Hvis \`NULL\`, hentes metadata automatisk.

- countries:

  Valgfri vektor med land som skal inkluderes når \`data\` er et
  internasjonalt datasett.

## Value

Et \`ggplot\`-objekt.

## Details

Funksjonen støtter norske makrodata, internasjonale data med kolonnen
\`Land\` og KOSTRA-data med enhetsinformasjon.

## Examples

``` r
plot_series(
  "Inflasjon",
  data = normacro_example
)

```
