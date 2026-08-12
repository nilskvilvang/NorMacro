# Visualiser KOSTRA-benchmark

Visualiserer posisjonen til én KOSTRA-enhet i fordelingen av en valgt
indikator for ett år.

## Usage

``` r
plot_kostra_benchmark(variable, data, unit, year = NULL, descending = TRUE)
```

## Arguments

- variable:

  Navnet på KOSTRA-indikatoren.

- data:

  Et KOSTRA-datasett.

- unit:

  KOSTRA-koden til enheten som skal fremheves.

- year:

  Valgfritt år. Hvis \`NULL\`, brukes siste tilgjengelige år.

- descending:

  Logisk. Hvis \`TRUE\`, rangeres høyeste verdi først.

## Value

Et \`ggplot\`-objekt.

## Details

Figuren viser den valgte enheten sammen med median og intervallet mellom
første og tredje kvartil.

## Examples

``` r
plot_kostra_benchmark(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  unit = "0301",
  year = 2025
)

```
