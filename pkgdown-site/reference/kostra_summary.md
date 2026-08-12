# Oppsummer en KOSTRA-indikator

Lager en statistisk oppsummering av en KOSTRA-indikator for ett år.
Dersom \`year\` ikke oppgis, brukes siste tilgjengelige år.

## Usage

``` r
kostra_summary(variable, data, year = NULL)
```

## Arguments

- variable:

  Navnet på KOSTRA-indikatoren.

- data:

  Et KOSTRA-datasett.

- year:

  Valgfritt år. Hvis \`NULL\`, brukes siste tilgjengelige år.

## Value

En tibble med blant annet antall enheter, gjennomsnitt, median,
kvartiler, minimum, maksimum og standardavvik.

## Examples

``` r
kostra_summary(
  "Netto_driftsresultat",
  data = normacro_kostra_example
)
#> # A tibble: 1 × 10
#>   Variabel   Aar Antall_enheter Gjennomsnitt Median Minimum    Q1    Q3 Maksimum
#>   <chr>    <int>          <int>        <dbl>  <dbl>   <dbl> <dbl> <dbl>    <dbl>
#> 1 Netto_d…  2025              3         3.57    3.7       1  2.35  4.85        6
#> # ℹ 1 more variable: Standardavvik <dbl>
```
