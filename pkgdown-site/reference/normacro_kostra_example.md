# KOSTRA-eksempeldatasett fra NorMacro

Et lite, statisk KOSTRA-datasett med utvalgte kommunale nøkkeltall for
Oslo, Bergen og Trondheim i perioden 2020–2025.

## Usage

``` r
normacro_kostra_example
```

## Format

En tibble med 18 observasjoner og 7 variabler:

- Enhet:

  Kommunens KOSTRA-kode.

- Enhet_navn:

  Kommunens navn.

- Enhetstype:

  Type geografisk enhet.

- Aar:

  År.

- Netto_driftsresultat:

  Netto driftsresultat i prosent.

- Langsiktig_gjeld_uten_pensjonsforpliktelser:

  Langsiktig gjeld uten pensjonsforpliktelser i prosent.

- Frie_inntekter_per_innbygger:

  Frie inntekter per innbygger i kroner.

## Source

NorMacro. Statisk eksempel basert på KOSTRA-tabell 12134.

## Details

Datasettet er laget for bruk i eksempler, vignetter og dokumentasjon,
slik at KOSTRA-funksjonene kan demonstreres uten å hente data fra
eksterne API-er.

Datasettet representerer KOSTRA-tabell 12134, "Utvalgte nøkkeltall for
kommuneregnskap".

Datasettet har attributtene \`dataset_type\`, \`kostra_table\` og
\`kostra_title\`. Disse brukes av flere KOSTRA-funksjoner til å
identifisere datasettet og hente tilhørende metadata.
