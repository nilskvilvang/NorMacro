# Sammenlign KOSTRA-enheter

Sammenligner valgte KOSTRA-enheter for én indikator. Funksjonen kan
brukes både til sammenligning i ett år og til å beregne utviklingen
siden et angitt startår.

## Usage

``` r
compare_kostra_units(
  variable,
  data,
  units = NULL,
  year = NULL,
  start_year = NULL,
  descending = TRUE
)
```

## Arguments

- variable:

  Navnet på KOSTRA-indikatoren.

- data:

  Et KOSTRA-datasett.

- units:

  Valgfri tegnvektor med enhetskoder som skal inkluderes.

- year:

  Valgfritt sluttår. Hvis \`NULL\`, brukes siste tilgjengelige år.

- start_year:

  Valgfritt startår for beregning av endring over tid.

- descending:

  Logisk. Hvis \`TRUE\`, rangeres høyeste sluttverdi først.

## Value

En tibble med sammenligning av de valgte KOSTRA-enhetene.

## Examples

``` r
compare_kostra_units(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  units = c("0301", "4601", "5001"),
  start_year = 2020
)
#> # A tibble: 3 × 12
#>    Rang Enhet Enhet_navn Enhetstype   Aar Verdi Startaar Sluttaar Startverdi
#>   <int> <chr> <chr>      <chr>      <int> <dbl>    <dbl>    <int>      <dbl>
#> 1     1 5001  Trondheim  kommune     2025   6       2020     2025        4  
#> 2     2 0301  Oslo       kommune     2025   3.7     2020     2025        3.7
#> 3     3 4601  Bergen     kommune     2025   1       2020     2025        2.4
#> # ℹ 3 more variables: Sluttverdi <dbl>, Endring <dbl>,
#> #   Endring_prosentpoeng <dbl>
```
