# Utvikling.md

NorMacro – utviklings- og arkitekturdokument

## Formål

Dette dokumentet beskriver de overordnede prinsippene for utviklingen av **NorMacro**. Dokumentet skal fungere som prosjektets arkitektur og være retningsgivende for videre utvikling.

Målet er ikke å dokumentere implementasjonsdetaljer, men å beskrive prosjektets filosofi, designvalg og kriterier for videre utvidelser.

Ved tvil om hvordan prosjektet skal utvikles, skal prinsippene i dette dokumentet veie tyngre enn ønsket om å legge til flere dataserier eller funksjoner.

---

# Visjon

NorMacro skal utvikles til å bli en R-pakke for analyser av norsk makroøkonomi.

Prosjektet skal tilby et kuratert, dokumentert og reproducerbart datasett over sentrale makroøkonomiske indikatorer. Internasjonale data skal kun inkluderes når de bidrar til å forstå eller sette norsk økonomi i perspektiv.

NorMacro skal prioritere:

* kvalitet fremfor kvantitet
* konsistens fremfor kompleksitet
* faglig relevans fremfor datamengde
* enkel bruk fremfor eksponering av underliggende datakilder

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

# Prosjektstruktur

NorMacro deles konseptuelt inn i følgende moduler.

## Datainnhenting

Ansvar:

* hente rådata
* transformere data
* validere data

## Database

Ansvar:

* lagre ferdige datasett
* lagre metadata

## API

Ansvar:

* eksponere data gjennom enkle funksjoner

Eksempel:

```r
get_normacro()
```

Brukeren skal ikke trenge å kjenne underliggende API-er.

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

# Kriterier for nye variabler

En ny variabel bør oppfylle de fleste av følgende kriterier:

* beskriver et sentralt makroøkonomisk fenomen
* har en tydelig definisjon
* kommer fra en offentlig kilde
* kan oppdateres automatisk
* har tilstrekkelig historikk
* er stabil over tid
* har dokumentert metodikk
* gir merverdi for brukeren

Variabler som ikke oppfyller disse kriteriene bør normalt ikke inkluderes.

---

# Internasjonale data

## Formål

Internasjonale data skal ikke gjøre NorMacro til en internasjonal makrodatabase.

Formålet er å gjøre det enklere å analysere norsk økonomi gjennom relevante sammenligninger.

Den grunnleggende beslutningsregelen er:

> Internasjonale dataserier inkluderes kun dersom de bidrar til å forstå norsk makroøkonomi bedre.

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

# Metadata

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

# API-prinsipper

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

# Kvalitetssikring

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

## Versjon 1

* Norsk makrodatabase

Status: Ferdigstilt.

## Versjon 2

* Internasjonalt sammenligningslag
* Europeiske indikatorer
* Utvidede metadata

## Versjon 3

* Analysefunksjoner
* Sammenligningsverktøy
* Dashboards
* Automatisk rapportering

Roadmapen er veiledende og kan justeres underveis.

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

# Avslutning

NorMacro utvikles med mål om å bli en langsiktig referanse for analyser av norsk makroøkonomi.

Prosjektets verdi ligger ikke først og fremst i antallet dataserier, men i kvaliteten på utvalget, dokumentasjonen og brukeropplevelsen.

Alle videre utvidelser skal vurderes opp mot denne målsettingen.
