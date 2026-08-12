# Plot en KOSTRA-rangering

Visualiserer rangeringen av KOSTRA-enheter etter en valgt indikator i
ett år.

## Usage

``` r
plot_kostra_ranking(
  variable,
  data,
  year = NULL,
  units = NULL,
  highlight = NULL,
  descending = TRUE
)
```

## Arguments

- variable:

  Navnet på KOSTRA-indikatoren.

- data:

  Et KOSTRA-datasett.

- year:

  Valgfritt år. Hvis \`NULL\`, brukes siste tilgjengelige år.

- units:

  Valgfri tegnvektor med enhetskoder som skal inkluderes.

- highlight:

  Valgfri enhet som skal fremheves i figuren.

- descending:

  Logisk. Hvis \`TRUE\`, rangeres høyeste verdi først.

## Value

Et \`ggplot\`-objekt.

## Examples

``` r
plot_kostra_ranking(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  year = 2025
)

```
