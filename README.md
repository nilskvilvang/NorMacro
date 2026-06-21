# NorMacro

**Version:** 0.1.0

NorMacro er en åpen og reproduserbar makroøkonomisk database for Norge bygget i R.

Databasen henter data direkte fra offentlige kilder som SSB, Norges Bank, NAV og FRED, kombinerer dem til ett konsistent datasett og dokumenterer alle variabler gjennom metadata.

## Status

Per juni 2026:

- 33 variabler
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

| Variabel | Beskrivelse |
|---------|---------|
| Befolkning | Folkemengde per 1. januar |
| Befolkningsvekst | Årlig befolkningsvekst (%) |

### Arbeidsmarked

| Variabel | Beskrivelse |
|---------|---------|
| Arbeidsstyrke | Personer i arbeidsstyrken |
| Arbeidsstyrkeandel | Arbeidsstyrke som andel av befolkningen |
| Sysselsatte | Sysselsatte personer |
| Arbledige_NAV | Registrert arbeidsledighet |
| Arbledighetsrate_NAV | NAV-ledighet (%) |
| Arbledige_andel_arbeidsstyrke_NAV | Ledige som andel av arbeidsstyrken (%) |
| Menn_arbledige_NAV | Registrerte arbeidsledige menn |
| Kvinner_arbledige_NAV | Registrerte arbeidsledige kvinner |
| Kvinneandel_arbledige_NAV | Kvinners andel av registrerte ledige (%) |

### Priser

| Variabel | Beskrivelse |
|---------|---------|
| KPI | Konsumprisindeks (2025 = 100) |
| Inflasjon | Årlig inflasjon (%) |
| Boligprisindeks | Prisindeks for brukte boliger |
| Boligprisvekst | Årlig boligprisvekst (%) |

### Lønn

| Variabel | Beskrivelse |
|---------|---------|
| Lonn | Gjennomsnittlig årslønn (1 000 kroner) |
| Lonnvekst | Årlig lønnsvekst (%) |
| Reallonnsvekst | Lønnsvekst minus inflasjon (%) |

### Produksjon

| Variabel | Beskrivelse |
|---------|---------|
| BNP_lopende | BNP i løpende priser |
| BNP_Fastland | BNP Fastlands-Norge i faste priser |
| BNP_Fastland_vekst | Årlig BNP-vekst (%) |

### Finans og valuta

| Variabel | Beskrivelse |
|---------|---------|
| Styringsrente | Norges Banks styringsrente (%) |
| Valutakurs_I44 | Importveid kronekursindeks (I-44) |
| Valutakurs_I44_vekst | Årlig endring i I-44 (%) |

### Energi

| Variabel | Beskrivelse |
|---------|---------|
| Oljepris_USD | Brent oljepris (USD per fat) |
| Oljeprisvekst | Årlig vekst i oljepris (%) |

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