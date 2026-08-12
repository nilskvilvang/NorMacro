# Benchmark en KOSTRA-enhet

Sammenligner én KOSTRA-enhet med et valgt sammenligningsgrunnlag for én
indikator og ett år.

## Usage

``` r
benchmark_kostra(
  variable,
  data = NULL,
  unit = NULL,
  year = NULL,
  descending = TRUE,
  comparison = c("data", "kostra_group", "county", "custom"),
  comparison_units = NULL,
  comparison_name = NULL,
  table = "12134"
)
```

## Arguments

- variable:

  Navnet på KOSTRA-indikatoren.

- data:

  Valgfritt KOSTRA-datasett. Må oppgis når \`comparison = "data"\`.

- unit:

  KOSTRA-koden til enheten som skal analyseres.

- year:

  Valgfritt år. Hvis \`NULL\`, brukes siste relevante år.

- descending:

  Logisk. Hvis \`TRUE\`, rangeres høyeste verdi først.

- comparison:

  Sammenligningsgrunnlag: \`"data"\`, \`"kostra_group"\`, \`"county"\`
  eller \`"custom"\`.

- comparison_units:

  Valgfri tegnvektor med enhetskoder når \`comparison = "custom"\`.

- comparison_name:

  Valgfritt navn på en egendefinert sammenligningsgruppe.

- table:

  KOSTRA-tabell. Standard er \`"12134"\`.

## Value

Et objekt av klassen \`kostra_benchmark\` med verdi, rang, percentil og
fordelingsmål for sammenligningsgruppen.

## Details

Sammenligningsgrunnlaget kan være enhetene i et eksisterende datasett,
enhetens KOSTRA-gruppe, fylke eller en egendefinert gruppe.

## Examples

``` r
benchmark_kostra(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  unit = "0301",
  year = 2025
)
#> # A tibble: 1 × 16
#>   Enhet Enhet_navn Enhetstype   Aar Variabel          Verdi  Rang Antall_enheter
#>   <chr> <chr>      <chr>      <dbl> <chr>             <dbl> <int>          <int>
#> 1 0301  Oslo       kommune     2025 Netto_driftsresu…   3.7     2              3
#> # ℹ 8 more variables: Percentil <dbl>, Gjennomsnitt <dbl>, Median <dbl>,
#> #   Avvik_gjennomsnitt <dbl>, Avvik_median <dbl>, Q1 <dbl>, Q3 <dbl>,
#> #   Kvartil <int>
```
