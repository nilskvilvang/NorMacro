# Konjunkturklassifisering

## Konjunkturklassifisering

NorMacro inneholder en enkel og transparent konjunkturklassifisering
gjennom funksjonene
[`business_cycle()`](https://nilskvilvang.github.io/NorMacro/reference/business_cycle.md)
og
[`business_cycle_explain()`](https://nilskvilvang.github.io/NorMacro/reference/business_cycle_explain.md).

Klassifiseringen bygger internt på en indikatorbasert score.

Klassifiseringen er ikke en offisiell konjunkturprognose. Den er en
indikatorbasert og regelstyrt vurdering av konjunktursituasjonen.

### Indikatorer

Modellen bruker som standard:

- BNP Fastlands-Norge, årlig vekst
- NAV-ledighet
- SSBs sammensatte konjunkturindikator
- kapasitetsutnytting
- rentekurve

### Poengsetting

#### BNP-vekst

|         Verdi | Poeng |
|--------------:|------:|
|         `< 0` |    -2 |
|  `0 <= x < 1` |    -1 |
| `1 <= x <= 3` |     1 |
|         `> 3` |     2 |

#### NAV-ledighet

|         Verdi | Poeng |
|--------------:|------:|
|         `> 5` |    -2 |
|  `3 < x <= 5` |    -1 |
| `2 <= x <= 3` |     1 |
|         `< 2` |     2 |

#### Konjunkturindikator

|         Verdi | Poeng |
|--------------:|------:|
|        `< -5` |    -2 |
| `-5 <= x < 0` |    -1 |
| `0 <= x <= 5` |     1 |
|         `> 5` |     2 |

#### Kapasitetsutnytting

|           Verdi | Poeng |
|----------------:|------:|
|          `< 75` |    -1 |
| `75 <= x <= 80` |     0 |
|          `> 80` |     1 |

#### Rentekurve

|  Verdi | Poeng |
|-------:|------:|
|  `< 0` |    -1 |
| `>= 0` |     1 |

### Vekting

Som standard vektes indikatorene slik:

| Indikator           | Vekt |
|---------------------|-----:|
| BNP-vekst           |    2 |
| NAV-ledighet        |    2 |
| Konjunkturindikator |    2 |
| Kapasitetsutnytting |    1 |
| Rentekurve          |    1 |

Poengene for hver indikator multipliseres med vekten før de summeres til
samlet score.

### Klassifisering

|              Score | Fase          |
|-------------------:|---------------|
|            `<= -8` | Nedgang       |
| `-8 < score <= -2` | Svak vekst    |
|   `-2 < score < 6` | Ekspansjon    |
|             `>= 6` | Høykonjunktur |

### Eksempel

``` r

business_cycle()

business_cycle_explain(2020)
```

[`business_cycle_explain()`](https://nilskvilvang.github.io/NorMacro/reference/business_cycle_explain.md)
viser hvordan delpoengene summeres for et enkelt år.

### Metodisk merknad

Klassifiseringen er ment som et pedagogisk og analytisk hjelpemiddel.
Den bør ikke tolkes som en offisiell konjunkturprognose.
