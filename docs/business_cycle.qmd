# Konjunkturklassifisering

NorMacro inneholder en enkel og transparent konjunkturklassifisering gjennom funksjonene:

```r
business_cycle_score()
business_cycle()
business_cycle_explain()
```

Klassifiseringen er ikke en offisiell konjunkturprognose. Den er en indikatorbasert og regelstyrt vurdering av konjunktursituasjonen.

## Indikatorer

Modellen bruker som standard:

- BNP Fastlands-Norge, årlig vekst
- NAV-ledighet
- SSBs sammensatte konjunkturindikator
- kapasitetsutnytting
- rentekurve

## Poengsetting

### BNP-vekst

|   Verdi | Poeng |
| ------: | ----: |
|     < 0 |    -2 |
| 0 til 1 |    -1 |
| 1 til 3 |     1 |
|     > 3 |     2 |

### NAV-ledighet

|   Verdi | Poeng |
| ------: | ----: |
|     > 5 |    -2 |
| 3 til 5 |    -1 |
| 2 til 3 |     1 |
|     < 2 |     2 |

### Konjunkturindikator

|    Verdi | Poeng |
| -------: | ----: |
|     < -5 |    -2 |
| -5 til 0 |    -1 |
|  0 til 5 |     1 |
|      > 5 |     2 |

### Kapasitetsutnytting

|     Verdi | Poeng |
| --------: | ----: |
|      < 75 |    -1 |
| 75 til 80 |     0 |
|      > 80 |     1 |

### Rentekurve

| Verdi | Poeng |
| ----: | ----: |
|   < 0 |    -1 |
|  >= 0 |     1 |

## Vekting

Som standard vektes indikatorene slik:

| Indikator           | Vekt |
| ------------------- | ---: |
| BNP-vekst           |    2 |
| NAV-ledighet        |    2 |
| Konjunkturindikator |    2 |
| Kapasitetsutnytting |    1 |
| Rentekurve          |    1 |

## Klassifisering

|     Score | Fase          |
| --------: | ------------- |
|     <= -8 | Nedgang       |
| -7 til -2 | Svak vekst    |
|  -1 til 5 | Ekspansjon    |
|      >= 6 | Høykonjunktur |

## Eksempel

```r
business_cycle()

business_cycle_explain(2020)
```
business_cycle_explain() viser hvordan delpoengene summeres for et enkelt år.

## Metodisk merknad

Klassifiseringen er ment som et pedagogisk og analytisk hjelpemiddel. Den bør ikke tolkes som en offisiell konjunkturprognose.
