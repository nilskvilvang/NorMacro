# Internasjonale kilder og valg

Dette dokumentet beskriver valg av internasjonale dataserier i NorMacro fase 2.

## Industriproduksjon

- NorMacro-variabel: `Industriproduksjon`
- Kilde: Eurostat
- Tabell: `sts_inpr_a`
- Filter:
  - `unit = I15`
  - `s_adj = CA`
  - `nace_r2 = C`
- Land: `get_standard_countries()`
- Periode: 1953–2025
- Begrunnelse:
  - `I15` brukes fordi vi ønsker indeksnivå, ikke ferdig vekstrate.
  - `CA` brukes fordi kalenderjusterte serier er bedre egnet for internasjonal sammenligning.
  - `C` brukes fordi dette tilsvarer manufacturing / bearbeidende industri og ligger nærmest norsk industriproduksjon.