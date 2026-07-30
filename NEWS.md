# NorMacro 2.0.2

## Nye funksjoner

- Lagt til et nytt KOSTRA-datalag med standardisert tilgang til
  utvalgte kommunale og regionale nøkkeltall.
- Lagt til funksjoner for finansielle nøkkeltall, nøkkeltall per
  innbygger, gjeld, finansielle grunnlagsdata, hovedoversikter og
  finansiering av drift og investeringer.
- Lagt til hjelpefunksjoner for KOSTRA-regioner, dimensjoner og
  dimensjonsmetadata.
- `overview()` støtter nå KOSTRA-datasett og viser tabellnummer,
  tabelltittel, periode, antall observasjoner, enheter, variabler og
  enhetstyper.

## Forbedringer

- KOSTRA-datasett har fått konsistente attributter for datasettype,
  tabellnummer og tabelltittel.
- Lagt til en felles intern hjelpefunksjon for å sette
  KOSTRA-attributter.
- KOSTRA-tabellkonfigurasjonene inneholder nå standardiserte titler.
- Forbedret identifikasjon og oppsummering av ulike datasettyper i
  `overview()`.
- Metadata og kategorinavn er gjennomgått og ryddet.
- Standardisert metadata om tabellnummer og tabelltittel på tvers av
  KOSTRA-datasettene.

## Feilrettinger

- Rettet feilaktig tegnkoding i norske metadata, blant annet for
  bokstavene `æ`, `ø` og `å`.
- Fjernet utilsiktet videreføring av datasettattributter til interne
  oppsummeringstabeller i `overview()`.
  
Denne versjonen inneholder ingen planlagte inkompatible endringer i det
eksisterende API-et for norske eller internasjonale data.

