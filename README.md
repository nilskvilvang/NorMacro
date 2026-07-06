# NorMacro

**Version:** 0.8.0

NorMacro er en kuratert makroøkonomisk database for Norge som samler representative årlige indikatorer fra SSB, Norges Bank, NAV, Yahoo Finance og FRED i ett konsistent datasett. Databasen er dokumentert med metadata, kvalitetssikret gjennom automatiske tester og utstyrt med hjelpefunksjoner for søk, dokumentasjon, visualisering og utforsking.

## Status

Per juli 2026 inneholder NorMacro:

- 93 makroøkonomiske variabler
- 161 årsobservasjoner (1865–2025)
- 13 fagkategorier
- Full metadata for alle variabler
- Automatisk kvalitetskontroll og validering
- Lokal caching av datakilder
- Hjelpefunksjoner for søk, dokumentasjon og visualisering

## Formål

Målet med NorMacro er å tilby et enkelt og transparent datasett for:

- undervisning i samfunnsøkonomi
- analyser av norsk økonomi
- visualiseringer og dashboards
- forskning og metodeutvikling
- tidsserieanalyser og prognoser

Alle dataserier hentes automatisk fra relevante datakilder, i all hovedsak originalkilde.

## Hovedfunksjoner

- Automatisk nedlasting fra offentlige datakilder
- Lokal caching for raske oppslag
- Standardiserte metadata for alle variabler
- Automatisk metadata- og datavalidering
- Innebygde kvalitetskontroller
- Oversikt over datadekning (`coverage()`)
- Oversikt over ledende indikatorer (`leading_indicators()`)
- Utforsking av kategorier og metadata
- Visualisering med ggplot2 (`plot_series()`)
- Eksport til CSV, RDS og Excel

## Designprinsipper

NorMacro bygger på noen enkle prinsipper:

- én konsistent database
- én representativ tidsserie per økonomisk fenomen
- originale datakilder når det er mulig
- full dokumentasjon av alle variabler
- automatisk kvalitetssikring
- reproduserbar datainnhenting

## Installasjon

Klon prosjektet:

```bash
git clone https://github.com/nilskvilvang/NorMacro.git
```

Åpne prosjektet i RStudio.

## Kom i gang

```r
source("source_all.R")

install_dependencies()

overview()

normacro <- get_normacro()
```

Resultatet er et data.frame/tibble med alle tilgjengelige dataserier.

## NorMacro API

Data
-----
get_normacro()

Metadata
--------
get_metadata()
describe_variable()
search_variables()
list_categories()
list_variables()
category_variables()

Oversikt
---------
overview()
coverage()
about()
summary_normacro()

Analyse
--------
leading_indicators()
normalize_series()
compare_series()

Visualisering
-------------
plot_series()
conjuncture_dashboard()

## Utforske databasen

NorMacro inneholder metadata for alle variabler og flere hjelpefunksjoner for å utforske innholdet.

```r
overview()

coverage()

list_categories()

list_variables()

search_variables()

describe_variable()

leading_indicators()

category_variables()
```

## Visualisering

Alle serier kan plottes direkte gjennom funksjonen

```r
plot_series()
```

F.eks.:

```r
plot_series("BNP_Fastland")
```

Siden funksjonen returnerer et ordinært ggplot-objekt, kan plottet tilpasses videre.

```r
plot_series("BNP_Fastland") +
  ggplot2::labs(
    title = "BNP Fastlands-Norge"
  ) +
  ggplot2::theme_bw()
```

## Konjunkturklassifisering

`business_cycle()` klassifiserer år basert på en transparent poengmodell. Klassifiseringen er ikke en offisiell konjunkturdatering, men en enkel indikatorbasert vurdering.

Indikatorene som inngår er:

- BNP Fastlands-Norge, årlig vekst
- NAV-ledighet
- SSBs sammensatte konjunkturindikator
- kapasitetsutnytting
- rentekurve

Hver indikator får poeng etter forhåndsdefinerte terskler. De viktigste indikatorene gis høyere vekt. Funksjonen returnerer både delpoeng, totalscore og fase.

```r
business_cycle()

business_cycle_explain(2020)
```

## Datakilder

| Kilde | Beskrivelse |
|---------|---------|
| SSB | Befolkning, KPI, BNP, lønn, arbeidsmarked, boligpriser |
| NAV | Registrert arbeidsledighet |
| Norges Bank | Styringsrente og valutakurs |
| FRED | Brent oljepris |

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
- Produksjon og aktivitet
- Konjunkturindikatorer
- Utenriksøkonomi
- Energi og råvarer

For å se alle tilgjengelige variabler:

```r
list_variables()
```

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

NorMacro inneholder automatiske kvalitetskontroller og validering av både data og metadata.

```r
validate_metadata()

check_normacro()

testthat::test_dir("tests/testthat")
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
│   ├── install_dependencies.R
│   ├── get_metadata.R
│   ├── validate_metadata.R
│   ├── check_normacro.R
│   ├── overview.R
│   ├── coverage.R
│   ├── leading_indicators.R
│   ├── category_variables.R
│   ├── list_categories.R
│   ├── list_variables.R
│   ├── search_variables.R
│   ├── describe_variable.R
│   ├── plot_series.R
│   └── utils.R
│
├── data/
│   └── metadata.csv
│
├── cache/
│
├── scripts/
│
├── tests/
│   └── testthat/
│       ├── helper-setup.R
│       ├── test_build.R
│       ├── test_coverage.R
│       ├── test_derived.R
│       ├── test_metadata.R
│       ├── test_overview.R
│       ├── test_search.R
│       └── test_validation.R
│
├── source_all.R
├── NEWS.md
└── README.md
```
## Filstruktur

- `get_*.R` – henter og klargjør enkeltserier.
- `build_database.R` – bygger NorMacro.
- `create_derived_variables.R` – beregner avledede indikatorer.
- `cache_get.R` – lokal caching.
- `ssb_get.R` – standardiserte kall mot SSB.
- `install_dependencies.R` – installerer nødvendige pakker.
- `metadata.csv` – dokumentasjon av alle variabler.
- `overview()` og `coverage()` – oppsummerer databasen.
- `leading_indicators()` – returnerer sentrale konjunkturindikatorer.
- `plot_series()` – lager ggplot-objekter.
- `tests/` – automatiske tester.


## Reproduserbarhet

NorMacro inneholder ingen manuelt vedlikeholdte data. Alle tidsserier lastes ned direkte fra de opprinnelige datakildene. Den eneste vedlikeholdte datafilen er metadata.csv, som dokumenterer variablene.

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