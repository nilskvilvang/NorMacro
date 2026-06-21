# NorMacro

**Version:** 0.7.0

NorMacro er en norsk makroøkonomisk database som automatisk bygger et datasett med 55 dokumenterte makroøkonomiske indikatorere.
Databasen henter data direkte fra offentlige kilder som SSB, Norges Bank, NAV og FRED, kombinerer dem til ett konsistent datasett og dokumenterer alle variabler gjennom metadata.

## Status

Per juni 2026:

- 53 variabler
- 161 årsobservasjoner
- SSB
- NAV
- Norges Bank
- FRED
- Yahoo Finance

## Formål

Målet med NorMacro er å tilby et enkelt og transparent datasett for:

- undervisning i samfunnsøkonomi
- analyser av norsk økonomi
- visualiseringer og dashboards
- forskning og metodeutvikling
- tidsserieanalyser og prognoser

Alle dataserier hentes automatisk fra originale datakilder.

---

## Datakilder

| Kilde | Beskrivelse |
|---------|---------|
| SSB | Befolkning, KPI, BNP, lønn, arbeidsmarked, boligpriser |
| NAV | Registrert arbeidsledighet |
| Norges Bank | Styringsrente og valutakurs |
| FRED | Brent oljepris |

---

## Variabler

### Demografi
- Befolkning
- Befolkningsvekst

### Priser og inflasjon
- KPI
- Inflasjon
- Strømpris
- Strømprisvekst

### Arbeidsmarked
- Arbeidsstyrke
- Sysselsatte
- Arbledige_NAV
- Arbledighetsrate_NAV
- ...

### Lønn og inntekt
- Lonn
- Lonnvekst
- Reallonnsvekst
- Disponibel_inntekt_husholdninger

### Boligmarked
- Boligprisindeks
- Boligprisvekst
- Boliginvesteringer
- Boliginvesteringer_vekst
- Boliginvesteringer_andel_BNP

### Kreditt og husholdninger
- Kreditt_K2
- Kredittvekst_K2
- Husholdningsgjeldsrate
- Husholdningsgjeldsvekst
- Husholdningsfordringsrate
- Husholdningsnettofordringsrate

### Finansmarkeder
- Styringsrente
- Valutakurs_I44
- Valutakurs_I44_vekst
- OSEAX
- OSEAX_vekst

### Offentlig sektor
- Offentlig_gjeld
- Offentlig_nettofordringer
- Offentlig_gjeld_andel_BNP
- Offentlig_nettofordringer_andel_BNP
- Offentlige_utgifter
- Statlige_utgifter
- Kommunale_utgifter
- Kommunal_utgiftsandel
- Statlig_utgiftsandel

### Nasjonalregnskap og handel
- BNP_lopende
- BNP_Fastland
- BNP_Fastland_vekst
- Eksport
- Eksportvekst
- Import
- Importvekst

### Energi og råvarer
- Oljepris_USD
- Oljeprisvekst

---

## Installasjon

Klon prosjektet:

```bash
git clone https://github.com/nilskvilvang/NorMacro.git
```

Åpne prosjektet i RStudio.

Installer nødvendige pakker:

```r
install.packages(
  c(
    "tidyverse",
    "rio",
    "PxWebApiData",
    "quantmod",
    "zoo",
    "readr"
  )
)
```

---

## Bruk

Last inn alle funksjoner:

```r
source("source_all.R")
```

Bygg databasen:

```r
normacro <- get_normacro()
```

Resultatet er et data.frame/tibble med alle tilgjengelige dataserier.

---

## Metadata

Alle variabler dokumenteres gjennom:

```r
metadata <- get_metadata()
```

Kontroller at alle variabler er dokumentert:

```r
check_metadata(normacro)
```

Forventet resultat:

```text
✓ Alle variabler er dokumentert i metadata.
```

---

## Kvalitetskontroll

NorMacro har en enkel kvalitetskontroll som kjøres automatisk når databasen bygges med:

```r
normacro <- get_normacro()
```

Funksjonen check_normacro() kontrollerer at:

 - datasettet har en variabel som heter Aar
 - årgangene er sortert stigende
 - det ikke finnes dupliserte år
 - alle variabler er dokumentert i metadata

## Eksport

Eksporter database og metadata:

```r
normacro <- get_normacro(export = TRUE)
```

Dette oppretter:

```text
data_clean/
├── normacro.csv
├── normacro.rds
├── metadata.csv
└── metadata.xlsx
```

---

## Prosjektstruktur

```text
NorMacro/
│
├── R/
│   ├── get_kpi.R
│   ├── get_befolkning.R
│   ├── get_arbeidsstyrke.R
│   ├── get_sysselsatte.R
│   ├── get_ledighet.R
│   ├── get_rente.R
│   ├── get_valutakurs.R
│   ├── get_bnp_lopende.R
│   ├── get_bnp_fastland.R
│   ├── get_lonn.R
│   ├── get_boligpriser.R
│   ├── get_oljepris.R
│   ├── build_database.R
│   ├── get_metadata.R
│   ├── get_normacro.R
│   └── utils.R
│
├── source_all.R
├── README.md
└── .gitignore
```

---

## Reproduserbarhet

NorMacro inneholder ingen manuelt vedlikeholdte datafiler.

Alle dataserier lastes ned direkte fra kildene ved kjøring, slik at databasen alltid oppdateres med siste tilgjengelige observasjoner.

---

## Lisens

Datakildene tilhører de respektive institusjonene:

- Statistisk sentralbyrå (SSB)
- Norges Bank
- NAV
- Federal Reserve Economic Data (FRED)

NorMacro distribuerer kun kode for innhenting og bearbeiding av offentlig tilgjengelige data.