
# Internasjonale data

NorMacro inneholder en egen internasjonal makrodatabase.

Datasettet bygger hovedsakelig på Eurostat og inneholder harmoniserte makroøkonomiske indikatorer for europeiske land.

---

## Laste inn data

```r
international <- get_international_macro()
```

Datasettet inneholder blant annet:

- Land
- Aar
- makroøkonomiske indikatorer

---

## Velge land

Analysefunksjonene arbeider med ett land om gangen.

```r
sweden <-
  international |>
  dplyr::filter(
    Land == "SE"
  )
```

Deretter kan de vanlige funksjonene brukes.

```r
plot_series(
  "BNP_vekst",
  data = sweden
)
```

```r
compare_series(
  c(
    "BNP_vekst",
    "Inflasjon"
  ),
  data = sweden
)
```

```r
scatter_series(
  x = "BNP_vekst",
  y = "Arbeidsledighetsrate",
  data = sweden
)
```

---

## Metadata

Metadata for de internasjonale seriene hentes med

```r
get_international_metadata()
```

eller

```r
get_metadata(international)
```

---

## Datakilder

Hovedkilden er Eurostat.

Metadata inneholder informasjon om:

- datakilde
- tabell
- enhet
- frekvens
- tidsdekning
- funksjonen som har hentet data

---

## Prinsipper

Den internasjonale databasen følger de samme prinsippene som NorMacro:

- én rad per land og år
- én representativ serie per fenomen
- standardiserte metadata
- transparente beregninger
- automatisk kvalitetskontroll