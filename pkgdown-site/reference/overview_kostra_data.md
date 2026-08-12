# Gi oversikt over et KOSTRA-datasett

Oppsummerer strukturen i et standardisert KOSTRA-datasett og viser blant
annet tabellinformasjon, datadekning, antall enheter, antall variabler
og hvilke enhetstyper datasettet inneholder.

## Usage

``` r
overview_kostra_data(data, print = TRUE)
```

## Arguments

- data:

  Et standardisert KOSTRA-datasett.

- print:

  Logisk. Hvis \`TRUE\`, skrives en lesbar oversikt til konsollen.

## Value

Resultatet returneres usynlig. Når \`print = TRUE\`, skrives oversikten
også til konsollen.

## Examples

``` r
overview_kostra_data(
  normacro_kostra_example
)
#> 
#> KOSTRA-data
#> ===========
#> 
#> Tabell: 12134
#> Tema:   Utvalgte nøkkeltall for kommuneregnskap
#> 
#> Kommunale og regionale nøkkeltall fra KOSTRA.
#> 
#> Dekning
#> -------
#> Periode:        2020-2025
#> Observasjoner:  18
#> Enheter:        3
#> Variabler:      3
#> 
#> Enhetstyper
#> -----------
#> kommune                          3
#> 
```
