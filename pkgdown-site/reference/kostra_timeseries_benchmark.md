# Benchmark en KOSTRA-enhet over tid

Følger posisjonen til én KOSTRA-enhet over tid relativt til et valgt
sammenligningsgrunnlag.

## Usage

``` r
kostra_timeseries_benchmark(
  variable,
  data = NULL,
  unit,
  start_year = NULL,
  end_year = NULL,
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

- start_year:

  Valgfritt første år i analyseperioden.

- end_year:

  Valgfritt siste år i analyseperioden.

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

Et objekt av klassen \`kostra_timeseries_benchmark\` med årlige verdier,
rangering og fordelingsmål for valgt enhet.

## Details

For hvert år beregnes blant annet rang, percentil, gjennomsnitt, median
og kvartiler.

## Examples

``` r
kostra_timeseries_benchmark(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  unit = "0301",
  start_year = 2020,
  end_year = 2025
)
#> # A tibble: 6 × 12
#>   Enhet Enhet_navn Enhetstype   Aar Verdi  Rang Antall_enheter Gjennomsnitt
#>   <chr> <chr>      <chr>      <int> <dbl> <int>          <int>        <dbl>
#> 1 0301  Oslo       kommune     2020   3.7     2              3        3.37 
#> 2 0301  Oslo       kommune     2021   4.5     3              3        5.23 
#> 3 0301  Oslo       kommune     2022   5.4     1              3        3.8  
#> 4 0301  Oslo       kommune     2023  -0.8     3              3        0.567
#> 5 0301  Oslo       kommune     2024  -0.9     1              3       -1.4  
#> 6 0301  Oslo       kommune     2025   3.7     2              3        3.57 
#> # ℹ 4 more variables: Median <dbl>, Q1 <dbl>, Q3 <dbl>, Percentil <dbl>
```
