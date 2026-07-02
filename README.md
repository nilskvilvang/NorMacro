# NorMacro

**Version:** 0.7.2

NorMacro er en selvdokumenterende makroøkonomisk database for Norge. Alle variabler har standardiserte metadata med beskrivelse, kilde, enhet, dekning og funksjonsreferanse. Databasen inneholder innebygde verktøy for å utforske variabler, kontrollere datakvalitet og dokumentere tidsseriedekning.

## Hovedfunksjoner

- Automatisk nedlasting fra offentlige datakilder
- Lokal cache for raske oppslag
- Standardiserte metadata for alle variabler
- Automatisk validering av metadata
- Innebygde kvalitetskontroller
- Oversikt over datadekning (`coverage()`)
- Søk og dokumentasjon av variabler
- Eksport til CSV, RDS og Excel

## Kom i gang

```r
source("source_all.R")

overview()

normacro <- get_normacro()
```

## Utforske databasen

NorMacro inneholder metadata for alle variabler.

```r
overview()

list_categories()

list_variables()

search_variables()

describe_variable()

coverage()
```

## Status

Pr 1.juli 2026 inneholder NorMacro:

- 88 makroøkonomiske variabler
- 161 årsobservasjoner (1865–2025)
- 13 fagkategorier
- Full metadata for alle variabler
- Automatisk kvalitetskontroll
- Lokal caching
- Selvdokumenterende hjelpefunksjoner

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

NorMacro organiserer variablene i følgende kategorier:

- Demografi
- Priser og inflasjon
- Arbeidsmarked
- Lønn og inntekt
- Husholdningsøkonomi
- Boligmarked
- Kreditt og husholdninger
- Finansmarkeder
- Offentlige finanser
- Nasjonalregnskap
- Utenriksøkonomi
- Energi og råvarer

For å se alle tilgjengelige variabler:

```r
list_variables()
```

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

Installer nødvendige pakker (hvis nødvendig):

```r
install_dependencies()
```

Få oversikt:

```r
overview()
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

```r
get_kpi(refresh = TRUE)
```
For å slette all cache:

```r
unlink("cache", recursive = TRUE)
```

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
│   ├── get_*.R
│   ├── build_database.R
│   ├── create_derived_variables.R
│   ├── cache_get.R
│   ├── ssb_get.R
│   ├── get_metadata.R
│   ├── validate_metadata.R
│   ├── check_normacro.R
│   ├── overview.R
│   ├── coverage.R
│   ├── list_categories.R
│   ├── list_variables.R
│   ├── search_variables.R
│   ├── describe_variable.R
│   └── utils.R
│
├── data/
│   └── metadata.csv
│
├── cache/
├── scripts/
├── tests/
│   └── testthat/
│
├── source_all.R
├── NEWS.md
└── README.md
```

## Filstruktur

- `R/get_*.R` henter og klargjør enkeltserier fra eksterne datakilder.
- `R/build_database.R` bygger NorMacro ved å koble alle serier på `Aar`.
- `R/create_derived_variables.R` beregner avledede indikatorer.
- `R/cache_get.R` håndterer lokal caching av nedlastede datasett.
- `R/ssb_get.R` standardiserer kall mot SSBs PXWEB-API.
- `data/metadata.csv` inneholder dokumentasjon for alle variabler.
- `R/get_metadata.R` leser metadata inn i R.
- `R/validate_metadata.R` validerer struktur og innhold i metadata.
- `R/check_normacro.R` kjører kvalitetskontroller av databasen.
- `R/overview.R` og øvrige hjelpefunksjoner (`coverage()`, `list_*()`, `search_variables()`, `describe_variable()`) gjør databasen selvdokumenterende.
- `tests/testthat/` inneholder automatiske enhetstester.
- `cache/` inneholder lokale `.rds`-filer og versjonshåndteres ikke.

---

## Reproduserbarhet

NorMacro inneholder ingen manuelt vedlikeholdte **tidsserier**. Alle makroøkonomiske data lastes ned automatisk fra de opprinnelige datakildene. Den eneste vedlikeholdte datafilen er `metadata.csv`, som dokumenterer variablene.

Alle dataserier lastes ned direkte fra kildene ved kjøring, slik at databasen alltid oppdateres med siste tilgjengelige observasjoner.

---

## Metadata og variabelsøk

NorMacro inneholder metadata for alle variabler.

search_variables() søker i variabelnavn, beskrivelser og kommentarer.

describe_variable() viser metadata for én enkelt variabel.

Eksempler:  

```r
search_variables("konsum")
describe_variable("BNP_Fastland")
```

### Vedlikehold av metadata

`data/metadata.csv` er NorMacros "single source of truth" for variabelmetadata.

Filen bør redigeres i en teksteditor (f.eks. Notepad++ eller VS Code), ikke i Excel, for å unngå at CSV-formatet endres.
---

## Lisens

Datakildene tilhører de respektive institusjonene:

- Statistisk sentralbyrå (SSB)
- Norges Bank
- NAV
- Federal Reserve Economic Data (FRED)

NorMacro distribuerer kun kode for innhenting og bearbeiding av offentlig tilgjengelige data.