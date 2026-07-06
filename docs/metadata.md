# Metadata i NorMacro

NorMacro er metadata-drevet. Alle variabler dokumenteres gjennom én sentral metadatafil:

```text
data/metadata.csv
```

Denne filen fungerer som prosjektets **single source of truth** for variabeldokumentasjon.

## Formål

Metadata brukes av en rekke funksjoner i NorMacro:

- `overview()`
- `coverage()`
- `describe_variable()`
- `search_variables()`
- `list_categories()`
- `category_variables()`
- `growth_table()`
- `latest_observations()`
- `missing_data()`
- `variable_summary()`

Metadata benyttes både til dokumentasjon og til automatisk kvalitetskontroll.

---

## Variabler

Metadatafilen inneholder blant annet følgende felter:

| Felt | Beskrivelse |
|------|-------------|
| Variabel | Internt variabelnavn brukt i NorMacro |
| Beskrivelse | Kort beskrivelse av variabelen |
| Kategori | Tematisk kategori |
| Type | Original eller beregnet serie |
| Enhet | Måleenhet |
| Kilde | Opprinnelig datakilde |
| Frekvens | Opprinnelig publiseringsfrekvens |
| Kommentar | Eventuelle merknader |

Ved behov kan metadata utvides med flere felt uten at datastrukturen endres.

---

## Kategorier

Per i dag benytter NorMacro følgende hovedkategorier:

- Demografi
- Arbeidsmarked
- Priser og inflasjon
- Lønn og inntekt
- Husholdningsøkonomi
- Boligmarked
- Kreditt og husholdninger
- Finansmarkeder
- Nasjonalregnskap
- Produksjon og aktivitet
- Konjunkturindikatorer
- Offentlige finanser
- Utenriksøkonomi
- Energi og råvarer
- Aggregerte serier

---

## Vedlikehold

Metadata oppdateres når:

- nye variabler legges til
- variabler endrer definisjon
- nye kategorier opprettes

NorMacro kontrollerer automatisk at alle variabler finnes i metadata.

```r
validate_metadata()

check_normacro()
```

---

## Prinsipper

Metadata følger noen enkle prinsipper:

- én rad per variabel
- konsistente variabelnavn
- korte beskrivelser
- tydelige enheter
- én primærkategori per variabel
- original kilde oppgis alltid

---

## Fremtidige utvidelser

Metadata kan senere utvides med informasjon som:

- publiseringslag
- revisjonshistorikk
- internasjonale klassifikasjoner
- visningsnavn for figurer
- nøkkelord for søk
- anbefalte sammenligningsserier

NorMacro er derfor bygd slik at metadata kan utvikles uten å endre analysefunksjonene.