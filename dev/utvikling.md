# Utvikling og arkitektur

NorMacro – utviklings- og arkitekturdokument

## Formål

Dette dokumentet beskriver de overordnede prinsippene for utviklingen av **NorMacro**. Dokumentet skal fungere som prosjektets arkitektur og være retningsgivende for videre utvikling.

Målet er ikke å dokumentere implementasjonsdetaljer, men å beskrive prosjektets filosofi, designvalg og kriterier for videre utvidelser.

Ved tvil om hvordan prosjektet skal utvikles, skal prinsippene i dette dokumentet veie tyngre enn ønsket om å legge til flere dataserier eller funksjoner.

---

# Visjon

NorMacro skal være en R-pakke for analyser av norsk økonomi på nasjonalt,
internasjonalt og kommunalt nivå.

Prosjektet skal tilby tre komplementære datalag:

1. norske makroøkonomiske indikatorer
2. internasjonale indikatorer som setter norsk økonomi i perspektiv
3. utvalgte kommunale og regionale nøkkeltall fra KOSTRA

NorMacro skal ikke forsøke å eksponere alle tilgjengelige dataserier.
Verdien skal ligge i kuratering, konsistens, dokumentasjon og enkel bruk.

NorMacro skal prioritere:

- kvalitet fremfor kvantitet
- konsistens fremfor kompleksitet
- faglig relevans fremfor datamengde
- offentlige originalkilder
- enkel bruk fremfor eksponering av underliggende API-er
- felles datastrukturer og konvensjoner på tvers av datalag
---

# Grunnprinsipper

## 1. NorMacro er en indikatorpakke

NorMacro er ikke en generell database over økonomiske dataserier.

Prosjektet bygger på begrepet **indikatorer**, ikke dataserier.

Hver variabel representerer ett økonomisk fenomen som brukeren normalt ønsker å analysere.

Eksempler:

* inflasjon
* arbeidsledighet
* BNP-vekst
* styringsrente
* boligpriser

Brukeren skal slippe å lete blant mange alternative serier.

---

## 2. Én indikator – én anbefalt serie

Hver indikator skal normalt representeres av én anbefalt dataserie.

Dette gir

* enklere API
* enklere dokumentasjon
* bedre sammenlignbarhet
* mindre vedlikehold

Alternative dataserier skal bare inkluderes dersom de representerer et vesentlig annet økonomisk fenomen.

---

## 3. Kvalitet fremfor datamengde

NorMacro skal ikke forsøke å dekke alle tilgjengelige dataserier.

En variabel inkluderes fordi den er nyttig – ikke fordi den eksisterer.

Prosjektet skal være kuratert.

---

## 4. Reproduserbarhet

Alle datasett skal kunne bygges automatisk fra offentlige datakilder.

Ingen manuelle endringer skal være nødvendige etter at datakildene er definert.

Alle transformasjoner skal være dokumenterte og reproducerbare.

---

## 5. Metadata er en del av databasen

Metadata er en integrert del av NorMacro.

Hver variabel skal være dokumentert med blant annet

* navn
* definisjon
* enhet
* frekvens
* datakilde
* startår
* sluttår
* kommentar
* internasjonal analog (dersom relevant)

Metadata skal brukes aktivt av funksjoner, dokumentasjon og nettsider.

---

# Arkitektur

NorMacro deles inn i følgende lag.

## Konfigurasjon

Konfigurasjonsobjekter beskriver datakilden og hvordan den skal leses.

For KOSTRA inkluderer dette blant annet:

- tabellnummer
- tabelltittel
- API-adresse
- dimensjonskoder
- innholdskoder

Konfigurasjon skal være adskilt fra datainnhenting og standardisering.

## Datainnhenting

Ansvar:

- hente rådata fra offentlige kilder
- bygge forespørsler
- håndtere lokal caching
- kontrollere grunnleggende respons og format

## Standardisering

Ansvar:

- gi variabler konsistente navn
- standardisere tidsvariabler og identifikatorer
- konvertere verdier til korrekte datatyper
- produsere en forutsigbar datastruktur

## Datasettmetadata

Datasett skal kunne identifiseres uten kun å basere seg på kolonnenavn.

Der det er relevant, brukes attributter for blant annet:

- datasettype
- tabellnummer
- tabelltittel

Attributtene skal settes etter at transformasjonene er fullført.

## Bruker-API

Offentlige funksjoner skal:

- ha enkle og konsistente argumenter
- skjule underliggende API-struktur
- returnere standardiserte data
- bruke de samme konvensjonene på tvers av datakilder

## Utforsking og analyse

Funksjoner som `overview()`, `coverage()` og `variable_summary()` skal
fungere som et felles lag over datasettene.

Funksjonene skal bruke metadata og datasettype aktivt, fremfor å kreve
at brukeren kjenner datasettets interne oppbygning.

## Dokumentasjon

Dokumentasjonen skal genereres automatisk der det er mulig.

---

# Datakilder

NorMacro skal primært benytte offentlige datakilder.

Prioritert rekkefølge:

1. SSB
2. Norges Bank
3. NAV
4. Eurostat
5. OECD
6. ECB
7. Andre offentlige institusjoner ved behov

For hver indikator skal én kilde defineres som primærkilde.

---

## Datalag

### Norske makrodata

Det norske makrodatasettet er prosjektets kjerne.

Hver variabel skal normalt representere én anbefalt indikator for et
sentralt økonomisk fenomen. Alternative serier skal bare inkluderes når
de representerer en vesentlig annen definisjon eller analytisk bruk.

### Internasjonale data

Internasjonale data skal gjøre det enklere å forstå og sammenligne norsk
økonomi.

Norske indikatorer er utgangspunktet. En internasjonal serie inkluderes
når den:

- har en tydelig norsk analog
- er tilstrekkelig sammenlignbar
- kommer fra en stabil og dokumentert kilde
- gir analytisk merverdi

NorMacro skal ikke utvikles til en generell internasjonal makrodatabase.

### KOSTRA-data

KOSTRA-datalaget skal tilby enkel og standardisert tilgang til et
kuratert utvalg kommunale og regionale nøkkeltall.

KOSTRA-støtten skal ikke være en generell wrapper rundt hele
Statistikkbankens KOSTRA-innhold. Nye tabeller skal velges ut fra
analytisk relevans, stabilitet og muligheten for å presentere dataene i
en konsistent struktur.

Alle standardiserte KOSTRA-datasett skal så langt det er mulig inneholde:

- `Enhet`
- `Enhet_navn`
- `Enhetstype`
- `Aar`

Indikatorene skal ligge i separate kolonner med konsistente og
forståelige variabelnavn.

Datasettene skal også inneholde attributter som identifiserer:

- datasettype
- KOSTRA-tabell
- tabelltittel

## Kriterier for nye data

En ny indikator eller KOSTRA-tabell bør oppfylle de fleste av følgende
kriterier:

- beskriver et sentralt økonomisk fenomen
- har en tydelig definisjon
- kommer fra en offentlig og stabil kilde
- kan oppdateres automatisk
- har tilstrekkelig historikk
- kan standardiseres på en konsistent måte
- har dokumentert metodikk
- gir tydelig merverdi for brukeren
- kan kvalitetssikres med automatiske tester

Det at data er tilgjengelig, er ikke i seg selv et argument for å
inkludere det.

---

## Designprinsipp

Norske indikatorer er utgangspunktet.

Prosessen skal være:

```
Norsk indikator
        │
        ▼
Finnes en god internasjonal analog?
        │
      Ja
        │
Legg til internasjonal serie
```

Ikke motsatt.

---

# Datasetkontrakter

Hvert datalag skal ha en tydelig og stabil datastruktur.

## Norske data

- én rad per år
- tidsvariabelen heter `Aar`
- én kolonne per indikator

## Internasjonale data

- én rad per land og år
- landvariabelen heter `Land`
- tidsvariabelen heter `Aar`
- én kolonne per indikator

## KOSTRA-data

- én rad per enhet og år
- enhetskode i `Enhet`
- enhetsnavn i `Enhet_navn`
- enhetstype i `Enhetstype`
- tidsvariabelen heter `Aar`
- én kolonne per indikator

Endringer i disse kontraktene skal behandles som potensielt
inkompatible API-endringer.

## Prioriterte datakilder

Internasjonale data prioriteres i følgende rekkefølge:

1. Eurostat
2. OECD
3. ECB
4. IMF (ved behov)
5. Verdensbanken (ved behov)

---

## Prioriterte land

Standardutvalget skal være begrenset.

Første prioritet:

* Norge
* Sverige
* Danmark
* Finland
* Island
* Tyskland
* Frankrike
* Nederland
* EU27
* Euroområdet
* OECD

Flere land kan støttes senere dersom det gir faglig verdi.

---

## Sammenlignbarhet

Alle internasjonale variabler skal klassifiseres.

Eksempel:

| Klasse | Betydning                  |
| ------ | -------------------------- |
| Full   | Direkte sammenlignbar      |
| Høy    | Små metodiske forskjeller  |
| Delvis | Krever forsiktighet        |
| Lav    | Begrenset sammenlignbarhet |

Denne informasjonen skal lagres i metadata.

---

## Metadata

Metadata skal være prosjektets sentrale kunnskapsbase.

Eksempel på metadatafelter:

* Variabel
* Displaynavn
* Beskrivelse
* Kategori
* Enhet
* Frekvens
* Primærkilde
* Startår
* Sluttår
* Kommentar
* Internasjonal analog
* Sammenlignbarhet
* Prioritet

Metadata skal brukes aktivt ved

* dokumentasjon
* validering
* nettsider
* API
* visualisering

---

## API-prinsipper

API-et skal være enkelt.

Brukeren skal tenke i indikatorer.

Eksempel:

```r
get_normacro()

variable_summary("Inflasjon")

compare_countries("Inflasjon")

plot_indicator("Arbeidsledighet")
```

Brukeren skal ikke måtte kjenne til hvilken institusjon som leverer dataene.

---

## Kvalitetssikring

Alle nye dataserier skal gjennomgå en standardisert kontroll.

Minimumskrav:

* korrekt enhet
* korrekt tidsakse
* ingen åpenbare avvik
* dokumentert kilde
* oppdaterte metadata
* fungerende tester

---

# Roadmap

## Versjon 1 – norsk makrodatabase

- norsk makrodatasett
- metadata
- grunnleggende datainnhenting
- kvalitetssikring

Status: ferdigstilt.

## Versjon 2 – flere datalag og felles API

- internasjonalt sammenligningslag
- europeiske indikatorer
- KOSTRA-data
- standardiserte datasettyper
- utvidede metadata
- felles funksjoner for utforsking og analyse

Status: aktiv utvikling.

## Videre utvikling

Aktuelle områder for videre utvikling:

- flere kuraterte KOSTRA-tabeller
- bedre land- og regionsammenligninger
- videreutvikling av analysefunksjoner
- forbedret dokumentasjon og nettsider
- tydeligere rapportering av datakvalitet og sammenlignbarhet
- automatiserte rapporter og dashboards

Roadmapen er veiledende. Nye funksjoner skal bare prioriteres når de
styrker prosjektets faglige verdi uten å svekke enkelhet og konsistens.

---

# Prinsipper som ikke skal brytes

NorMacro skal ikke utvikles til

* en generell wrapper rundt Eurostat
* en kopi av OECDs databaser
* en samling av flest mulig dataserier

NorMacro skal være

* kuratert
* konsistent
* dokumentert
* reproduserbar
* enkel å bruke

Når det oppstår tvil mellom å legge til flere data eller bevare prosjektets enkelhet, skal enkelhet og konsistens prioriteres.

---

## Avslutning

NorMacro utvikles med mål om å bli en langsiktig referanse for analyser av norsk makroøkonomi.

Prosjektets verdi ligger ikke først og fremst i antallet dataserier, men i kvaliteten på utvalget, dokumentasjonen og brukeropplevelsen.

Alle videre utvidelser skal vurderes opp mot denne målsettingen.
