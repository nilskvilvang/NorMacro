# NorMacro

**Version:** 1.0.0

NorMacro er en kuratert makroøkonomisk database for Norge som samler representative årlige indikatorer fra SSB, Norges Bank, NAV, Yahoo Finance og FRED i ett konsistent datasett. Databasen er dokumentert med metadata, kvalitetssikret gjennom automatiske tester og utstyrt med hjelpefunksjoner for søk, dokumentasjon, visualisering og utforsking.

## Filosofi

- representative indikatorer fremfor flest mulig serier
- full transparens i datagrunnlag og beregninger
- metadata som dokumentasjonslag
- små funksjoner som kan kombineres til større analyser

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
----
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
compare_periods()
growth_table()
correlation_matrix()
business_cycle()
business_cycle_score()
business_cycle_explain()
recession_periods()
recession_period_explain()
macro_report()

Visualisering
-------------
plot_series()
plot_correlation_matrix()
conjuncture_dashboard()

Diagnostikk
-----------
latest_observations()
missing_data()
variable_summary()

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

NorMacro inneholder en transparent indikatorbasert konjunkturklassifisering.

```r
business_cycle()
business_cycle_explain(2020)
```

Se `docs/business_cycle.md` for metode, vekter og poengsystem.

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

Alle variabler dokumenteres gjennom `metadata.csv`.

```r
get_metadata()
describe_variable("BNP_Fastland")
```

Se `docs/metadata.md`.

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

## Arkitektur

NorMacro/
R/
data/
cache/
tests/
docs/

Se docs/architecture.md

## Reproduserbarhet

NorMacro inneholder ingen manuelt vedlikeholdte data. Alle tidsserier lastes ned direkte fra de opprinnelige datakildene. Den eneste vedlikeholdte datafilen er metadata.csv, som dokumenterer variablene.

Alle dataserier lastes ned direkte fra kildene ved kjøring, slik at databasen alltid oppdateres med siste tilgjengelige observasjoner.

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

## Dokumentasjon

Utfyllende dokumentasjon finnes i `docs/`.

| Dokument | Innhold |
|-----------|----------|
| business_cycle.md | Konjunkturklassifisering |
| metadata.md | Metadata og dokumentasjon |
| architecture.md | Arkitektur og design |
| roadmap.md | Planlagt videreutvikling |

## Lisens

Datakildene tilhører de respektive institusjonene:

- Statistisk sentralbyrå (SSB)
- Norges Bank
- NAV
- Federal Reserve Economic Data (FRED)

NorMacro distribuerer kun kode for innhenting og bearbeiding av offentlig tilgjengelige data.