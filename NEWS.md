
# NorMacro 2.0.3

## Nye funksjoner

- Lagt til et objektbasert API for sammensatte analyser av norske og
  internasjonale tidsserier.
- `combine_series()` kombinerer norske og internasjonale serier i et
  felles `comparison_series`-objekt.
- Lagt til transformasjoner med `index()`, `normalize()` og `growth()`.
- Lagt til analyse av `comparison_series`-objekter med `correlate()`,
  `regress()` og `autocorrelate()`.
- Lagt til KOSTRA-funksjoner for rangering, sammenligning og benchmarking,
  inkludert tidsseriebenchmarking.
- Lagt til visualisering av KOSTRA-rangeringer og benchmarkanalyser.

## Forbedringer

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

## Feilrettinger

- Rettet duplisering av norske observasjoner ved kobling mot metadata i
  `combine_series()`.
- Forbedret validering av transformerte `comparison_series`-objekter.
- Ryddet opp i håndtering av indeksering og transformasjonsmetadata.
- Rettet dokumentasjon og vignettbygging slik at pakken passerer
  `R CMD check` uten feil, advarsler eller merknader.

Denne versjonen viderefører det eksisterende direkte analyse-API-et.
Det objektbaserte `comparison_series`-API-et er et tillegg for mer
sammensatte og kjedbare analyser.
