# NorMacro – status juni 2026

## Infrastruktur

* Alle datakilder er implementert som get_*()-funksjoner.
* Alle eksterne datakilder bruker cache_get().
* Cache lagres i cache/.
* cache/ ligger i .gitignore.
* Første bygging tar ca. 27 sekunder.
* Ny bygging fra cache tar ca. 0.25 sekunder.

## Kvalitet

* metadata.csv er komplett.
* check_metadata() validerer alle variabler.
* get_normacro() kjører kvalitetskontroller.
* testthat-tester passerer.

## Nåværende omfang

Ca. 57 variabler.

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

## Neste prioriteringer

1. Infrastrukturinvesteringer
2. Boligbygging
3. Næringsstruktur
4. Demografi

## Viktige konvensjoner

* Avledede variabler beregnes i create_derived_variables().
* Datainnhenting skjer kun i get_*()-funksjoner.
* Alle nye variabler skal ha metadata.
* Alle nye variabler skal testes.
* Cache brukes på alle eksterne datakilder.
