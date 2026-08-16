# Changelog

## NorMacro 2.1.0

### Nye data og faglig dekning

- Utvidet arbeidsmarkedsblokken med norsk AKU-ledighet, korrekt
  arbeidsstyrkeandel og sysselsettingsandel basert på befolkningen 15–74
  år.
- Utvidet offentlige finanser med offentlige inntekter,
  nettofinansinvestering og sentrale størrelser som andel av BNP.
- Lagt til internasjonale lønnsdata, ansatte, lønn per ansatt,
  lønnsvekst og reallønnsvekst.
- Utvidet og kvalitetssikret metadata for norske og internasjonale
  makroøkonomiske serier.

### Nye funksjoner

- Lagt til
  [`compare_countries()`](https://nilskvilvang.github.io/NorMacro/reference/compare_countries.md)
  for sammenligning av én makroøkonomisk variabel på tvers av land.
- Lagt til
  [`historical_episodes()`](https://nilskvilvang.github.io/NorMacro/reference/historical_episodes.md)
  med en kuratert katalog over sentrale norske makroøkonomiske episoder.
- Lagt til
  [`episode_explain()`](https://nilskvilvang.github.io/NorMacro/reference/episode_explain.md)
  for å koble historiske episoder til relevante NorMacro-data.

### Forbedringer

- Ryddet og standardisert NAV-navngivning fra `Arbledig*` til
  `Arbeidsledig*`.
- Forbedret arbeidsmarkedsdefinisjoner og skille mellom AKU- og
  NAV-ledighet.
- Forbedret internasjonal brukerflyt og landnavn i sammenligninger.
- Ryddet metadata, displaynavn, kategorier og analyseklassifisering.
- Gjennomført samlet faglig gap-analyse mot 14 makroøkonomiske
  kravområder og dokumentert eksplisitte restgap for senere utvikling.
- Oppdatert dokumentasjon og vignetter til dagens API.

### Kvalitet

- Utvidet testdekningen for nye data- og analysefunksjoner.
- Pakken passerer `R CMD check` uten feil, advarsler eller merknader.

## NorMacro 2.0.3

### Nye funksjoner

- Lagt til et objektbasert API for sammensatte analyser av norske og
  internasjonale tidsserier.
- [`combine_series()`](https://nilskvilvang.github.io/NorMacro/reference/combine_series.md)
  kombinerer norske og internasjonale serier i et felles
  `comparison_series`-objekt.
- Lagt til transformasjoner med
  [`index()`](https://nilskvilvang.github.io/NorMacro/reference/index.md),
  [`normalize()`](https://nilskvilvang.github.io/NorMacro/reference/normalize.md)
  og
  [`growth()`](https://nilskvilvang.github.io/NorMacro/reference/growth.md).
- Lagt til analyse av `comparison_series`-objekter med
  [`correlate()`](https://nilskvilvang.github.io/NorMacro/reference/correlate.md),
  [`regress()`](https://nilskvilvang.github.io/NorMacro/reference/regress.md)
  og
  [`autocorrelate()`](https://nilskvilvang.github.io/NorMacro/reference/autocorrelate.md).
- Lagt til KOSTRA-funksjoner for rangering, sammenligning og
  benchmarking, inkludert tidsseriebenchmarking.
- Lagt til visualisering av KOSTRA-rangeringer og benchmarkanalyser.

### Forbedringer

- Videreutviklet KOSTRA-API-et med et tydeligere skille mellom
  datainnhenting, metadata, analyse og visualisering.
- Forbedret metadatahåndtering for norske og internasjonale serier ved
  kombinasjon i samme analyse.
- `comparison_series`-objekter beholder informasjon om transformasjon,
  basisår og transformasjonsperiode gjennom analysearbeidsflyten.
- Lagt til egne utskrifts- og oppsummeringsmetoder for flere av de nye
  analyseobjektene.
- Utvidet dokumentasjonen med en egen vignett for det objektbaserte
  analyse-API-et og en egen KOSTRA-vignett.
- Oppdatert package-level dokumentasjon og README slik at norske data,
  internasjonale data, KOSTRA og de to analysearbeidsflytene beskrives
  tydeligere.

### Feilrettinger

- Rettet duplisering av norske observasjoner ved kobling mot metadata i
  [`combine_series()`](https://nilskvilvang.github.io/NorMacro/reference/combine_series.md).
- Forbedret validering av transformerte `comparison_series`-objekter.
- Ryddet opp i håndtering av indeksering og transformasjonsmetadata.
- Rettet dokumentasjon og vignettbygging slik at pakken passerer
  `R CMD check` uten feil, advarsler eller merknader.

Denne versjonen viderefører det eksisterende direkte analyse-API-et. Det
objektbaserte `comparison_series`-API-et er et tillegg for mer
sammensatte og kjedbare analyser.
