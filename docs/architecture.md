
# Arkitektur

NorMacro er bygd rundt noen enkle prinsipper:

- én samlet årlig database
- én rad per år
- én kolonne per variabel
- metadata som dokumentasjonslag
- små funksjoner som gjør én ting godt
- analysefunksjoner som returnerer standard R-objekter

## Hovedstruktur

NorMacro bygges i flere trinn:

1. enkeltserier hentes fra eksterne kilder
2. seriene caches lokalt
3. seriene kobles sammen på `Aar`
4. avledede variabler beregnes
5. metadata valideres
6. kvalitetskontroller kjøres

## Viktige komponenter

- `get_*.R` henter enkeltserier
- `cache_get.R` håndterer lokal cache
- `build_database.R` kobler serier sammen
- `create_derived_variables.R` beregner avledede indikatorer
- `metadata.csv` dokumenterer alle variabler
- `validate_metadata.R` kontrollerer metadata
- `check_normacro.R` kontrollerer databasen

## API-design

Funksjonene i NorMacro følger noen felles mønstre:

- `data = NULL` betyr at funksjonen selv henter databasen
- funksjoner returnerer vanlige R-objekter
- plottefunksjoner returnerer `ggplot`-objekter
- analysefunksjoner returnerer tibble, matrix eller liste
- metadata brukes til titler, enheter og dokumentasjon

## Reproduserbarhet

NorMacro inneholder ingen manuelt vedlikeholdte tidsserier. Alle data hentes fra opprinnelige kilder ved kjøring. Cache brukes kun for hastighet.

## Teststruktur

Testene ligger i `tests/testthat/` og dekker:

- bygging av databasen
- metadata
- validering
- søk og oversikt
- analysefunksjoner
- visualisering