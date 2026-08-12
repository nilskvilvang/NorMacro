# Visualiser KOSTRA-benchmark over tid

Visualiserer utviklingen for én KOSTRA-enhet sammen med fordelingen i et
valgt sammenligningsgrunnlag over tid.

## Usage

``` r
plot_kostra_timeseries_benchmark(
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

Et \`ggplot\`-objekt.

## Details

Figuren viser den valgte enhetens tidsserie, medianen i
sammenligningsgruppen og intervallet mellom første og tredje kvartil.

## Examples

``` r
plot_kostra_timeseries_benchmark(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  unit = "0301",
  start_year = 2020,
  end_year = 2025
)

```
