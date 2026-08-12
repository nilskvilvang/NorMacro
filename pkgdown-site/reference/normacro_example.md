# Eksempeldatasett fra NorMacro

Et lite, statisk utsnitt av NorMacro-datasettet for årlige norske
makroøkonomiske serier i perioden 2000–2025.

## Usage

``` r
normacro_example
```

## Format

En data.frame med 26 observasjoner og 17 variabler:

- Aar:

  År.

- KPI:

  Konsumprisindeks.

- Inflasjon:

  Årlig prosentvis vekst i KPI.

- Befolkning:

  Befolkning.

- Arbeidsstyrke:

  Personer i arbeidsstyrken.

- Sysselsatte:

  Sysselsatte personer.

- Arbledige_NAV:

  Registrerte arbeidsledige hos NAV.

- Arbledighetsrate_NAV:

  Registrert arbeidsledighet i prosent.

- Styringsrente:

  Norges Banks styringsrente.

- BNP_Fastland:

  BNP for Fastlands-Norge.

- BNP_Fastland_vekst:

  Årlig vekst i BNP for Fastlands-Norge.

- Lonnvekst:

  Årlig lønnsvekst.

- Boligprisindeks:

  Boligprisindeks.

- Boligprisvekst:

  Årlig vekst i boligprisindeksen.

- Oljepris_USD:

  Oljepris i USD per fat.

- Eksport:

  Eksport i faste priser.

- Import:

  Import i faste priser.

## Source

NorMacro. Dataene er et statisk utsnitt av data hentet og bearbeidet av
pakkens ordinære datainnhentingsfunksjoner.

## Details

Datasettet er laget for bruk i eksempler, vignett(er) og dokumentasjon,
slik at disse kan kjøres uten å hente hele NorMacro-datasettet.
