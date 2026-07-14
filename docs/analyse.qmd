
# Analyse

NorMacro inneholder en rekke hjelpefunksjoner for analyse av makroøkonomiske tidsserier.

---

## correlate_series()

Beregner parvise korrelasjoner mellom flere variabler.

```r
correlate_series(
  c(
    "Inflasjon",
    "Lonnvekst",
    "BNP_Fastland_vekst"
  )
)
```

Korrelasjon kan beregnes med:

- Pearson
- Spearman
- Kendall

```r
correlate_series(
  variables = c(
    "Inflasjon",
    "Lonnvekst"
  ),
  method = "spearman"
)
```

Resultatet inneholder blant annet:

- korrelasjon
- p-verdi
- signifikans
- antall observasjoner
- analyseperiode

---

## normalize_series()

Normaliserer flere tidsserier til et felles basisår.

```r
normalize_series(
  variables = c(
    "BNP_Fastland",
    "Privat_konsum"
  ),
  base_year = 2000
)
```

---

## variable_summary()

Gir en samlet beskrivelse av én variabel.

```r
variable_summary(
  "BNP_Fastland"
)
```

Oppsummeringen inkluderer blant annet:

- metadata
- dekningsgrad
- beskrivende statistikk
- korrelasjoner med andre variabler

---

## coverage()

Viser datadekning for alle variabler.

```r
coverage()
```

---

## overview()

Gir en samlet oversikt over databasen.

```r
overview()
```