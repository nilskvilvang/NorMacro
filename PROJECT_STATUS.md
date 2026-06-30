# NorMacro – status juni 2026

## Infrastruktur

* Alle datakilder er implementert som get_*()-funksjoner.
* Alle eksterne datakilder bruker cache_get().
* Cache lagres i cache/.
* cache/ ligger i .gitignore.
* Første bygging tar ca. 25-30 sekunder.
* Ny bygging fra cache tar ca. 0.25 sekunder.

## Kvalitet

* metadata.csv er komplett.
* check_metadata() validerer alle variabler.
* get_normacro() kjører kvalitetskontroller.
* testthat-tester passerer.

## Nåværende omfang

Ca. 61 variabler.

Hovedkategorier:

* Inflasjon
* Befolkning
* Arbeidsmarked
* BNP
* Lønn
* Boligmarked
* Finansmarked
* Utenrikshandel
* Kreditt
* Offentlige finanser
* Husholdningsgjeld

## Nylig lagt til

* Arbeidsproduktivitet
* Produktivitetsvekst
* BNP_Fastland_per_innbygger
* BNP_Fastland_per_innbygger_vekst
*Infrastrukturinvesteringer

## Neste prioriteringer

1. Boligbygging
2. Infrastruktur (mer detaljert)
3. Næringsstruktur
4. Demografi

## Struktur

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

## Filroller
 - source_all.R: laster alle R-filer i riktig rekkefølge.
 - R/cache_get.R: felles cache-funksjon for eksterne datakilder.
 - R/source_ssb.R: hjelpefunksjoner for SSB/PXWEB.
 - R/source_nav.R: hjelpefunksjoner knyttet til NAV-data.
 - R/get_*.R: én fil per datakilde eller dataserie.
 - R/build_database.R: henter alle enkeltserier og joiner dem på Aar.
 - R/create_derived_variables.R: beregner avledede variabler.
 - R/get_metadata.R: dokumenterer alle variabler.
 - R/check_normacro.R: kvalitetskontroller for ferdig database.
 - R/get_normacro.R: hovedfunksjon som bygger databasen og kjører kontroller.
 - tests/testthat/test-normacro.R: automatiske tester.
 - cache/: lokale cache-filer. Denne mappen ligger i .gitignore.

## Viktige konvensjoner

* Avledede variabler beregnes i create_derived_variables().
* Datainnhenting skjer kun i get_*()-funksjoner.
* Alle nye variabler skal ha metadata.
* Alle nye variabler skal testes.
* Cache brukes på alle eksterne datakilder.
