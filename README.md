# NorMacro

**Version:** 0.7.1

NorMacro er en norsk makroøkonomisk database som automatisk bygger et datasett med 71 dokumenterte makroøkonomiske indikatorere.
Databasen henter data direkte fra offentlige kilder som SSB, Norges Bank, NAV og FRED, kombinerer dem til ett konsistent datasett og dokumenterer alle variabler gjennom metadata.

## Status

Per juni 2026:

- 71 variabler
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

Alle dataserier hentes automatisk fra relevante datakilder, i all hovedsak originalkilde.

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

### Priser og inflasjon

### Arbeidsmarked

### Lønn og inntekt

### Boligmarked

### Kreditt og husholdninger

### Finansmarkeder

### Offentlig sektor

### Nasjonalregnskap og handel

### Energi og råvarer

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

## Cache

NorMacro cacher nedlastede datasett lokalt i mappen `cache/`.

Første kjøring laster ned data fra eksterne kilder (SSB, Norges Bank, NAV, FRED og Yahoo) og tar omtrent 20–30 sekunder.
Senere kjøringer bruker lokale `.rds`-filer og går betydelig raskere - normalt under ett sekund.

For å tvinge ny nedlasting:

get_kpi(refresh = TRUE)

For å slette all cache:

unlink("cache", recursive = TRUE)

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
├── .gitignore
├── DESCRIPTION
├── NEWS.md
├── PROJECT_STATUS.md
├── README.md
├── NorMacro.Rproj
├── source_all.R
│
├── R/
│   ├── cache_get.R
│   ├── source_ssb.R
│   ├── source_nav.R
│   ├── build_database.R
│   ├── get_normacro.R
│   ├── get_metadata.R
│   ├── check_metadata.R
│   ├── check_normacro.R
│   ├── create_derived_variables.R
│   ├── utils.R
│   │
│   ├── get_kpi.R
│   ├── get_befolkning.R
│   ├── get_arbeidsstyrke.R
│   ├── get_sysselsatte.R
│   ├── get_ledighet.R
│   ├── get_rente.R
│   ├── get_bnp_lopende.R
│   ├── get_bnp_fastland.R
│   ├── get_lonn.R
│   ├── get_boligpriser.R
│   ├── get_oljepris.R
│   ├── get_valutakurs.R
│   ├── get_utenrikshandel.R
│   ├── get_oseax.R
│   ├── get_strompris.R
│   ├── get_offentlig_finans.R
│   ├── get_offentlige_utgifter.R
│   ├── get_kreditt.R
│   ├── get_boliginvesteringer.R
│   ├── get_disponibel_inntekt.R
│   ├── get_husholdningsgjeld.R
│   └── get_offentlige_investeringer.R
│
├── tests/
│   └── testthat/
│       └── test-normacro.R
│
└── cache/
    └── *.rds
```

## Filstruktur

- `source_all.R` laster alle R-filer i riktig rekkefølge.
- `R/get_*.R` henter enkeltserier fra eksterne datakilder.
- `R/cache_get.R` håndterer lokal cache av eksterne datakall.
- `R/build_database.R` kobler alle serier sammen på `Aar`.
- `R/create_derived_variables.R` beregner avledede indikatorer.
- `R/get_metadata.R` dokumenterer alle variabler.
- `R/check_normacro.R` kjører kvalitetskontroller.
- `tests/testthat/` inneholder automatiske tester.
- `cache/` inneholder lokale `.rds`-filer og pushes ikke til GitHub.

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