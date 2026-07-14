
# Visualisering

NorMacro inneholder innebygde funksjoner for å visualisere både norske og internasjonale makroøkonomiske tidsserier.

Alle funksjonene returnerer ordinære `ggplot2`-objekter og kan derfor tilpasses videre.

---

## plot_series()

Plotter én tidsserie.

```r
plot_series("BNP_Fastland")
```

Siden funksjonen returnerer et ordinært ggplot-objekt, kan plottet tilpasses videre.

```r
plot_series("BNP_Fastland") +
  ggplot2::labs(
    title = "BNP Fastlands-Norge"
  ) +
  ggplot2::theme_bw()
```

Det er også mulig å plotte internasjonale serier.

```r
international <- get_international_macro()

sweden <-
  international |>
  dplyr::filter(Land == "SE")

plot_series(
  "BNP_vekst",
  data = sweden
)
```

---

## compare_series()

Sammenlikner flere tidsserier.

```r
compare_series(
  c(
    "BNP_Fastland",
    "Privat_konsum"
  )
)
```

Seriene kan normaliseres til et felles basisår.

```r
compare_series(
  c(
    "BNP_Fastland",
    "Privat_konsum"
  ),
  base_year = 2000
)
```

For internasjonale data må ett land velges.

```r
compare_series(
  c(
    "BNP_vekst",
    "Inflasjon"
  ),
  data = sweden
)
```

---

## scatter_series()

Undersøker sammenhengen mellom to variabler.

```r
scatter_series(
  x = "BNP_Fastland_vekst",
  y = "Arbledighetsrate_NAV"
)
```

Figuren viser:

- observasjoner
- lineær regresjonslinje
- korrelasjon
- R²
- p-verdi
- antall observasjoner

---

## Tilpasning

Alle funksjonene returnerer et vanlig `ggplot`-objekt.

```r
plot_series("BNP_Fastland") +
  ggplot2::theme_bw() +
  ggplot2::labs(
    title = "BNP Fastlands-Norge"
  )
```