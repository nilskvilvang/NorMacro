# Ranger KOSTRA-enheter

Rangerer kommuner eller andre KOSTRA-enheter etter verdien på en valgt
indikator i ett år.

## Usage

``` r
rank_kostra(variable, data, year = NULL, descending = TRUE, top_n = NULL)
```

## Arguments

- variable:

  Navnet på KOSTRA-indikatoren.

- data:

  Et KOSTRA-datasett.

- year:

  Valgfritt år. Hvis \`NULL\`, brukes siste tilgjengelige år.

- descending:

  Logisk. Hvis \`TRUE\`, rangeres høyeste verdi først.

- top_n:

  Valgfritt antall øverste enheter som skal returneres.

## Value

En tibble med rangering, enhetsinformasjon, år og verdi.

## Examples

``` r
rank_kostra(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  year = 2025
)
#> # A tibble: 3 × 6
#>    Rang Enhet Enhet_navn Enhetstype   Aar Verdi
#>   <int> <chr> <chr>      <chr>      <int> <dbl>
#> 1     1 5001  Trondheim  kommune     2025   6  
#> 2     2 0301  Oslo       kommune     2025   3.7
#> 3     3 4601  Bergen     kommune     2025   1  
```
