# List kategorier i NorMacro

Viser hvilke tematiske kategorier som finnes i et NorMacro-datasett,
samt hvor mange variabler som tilhører hver kategori.

## Usage

``` r
list_categories(data = NULL, print = TRUE)
```

## Arguments

- data:

  Valgfritt NorMacro-datasett. Hvis \`NULL\`, brukes standard norske
  makrodata.

- print:

  Logisk. Hvis \`TRUE\`, skrives resultatet til konsollen.

## Value

Resultatet returneres usynlig når det skrives til konsollen.

## Examples

``` r
list_categories(
  data = normacro_example
)
#> 
#> Norske data 
#> -----------
#> 9 kategorier
#> 16 variabler
#> 
#> # A tibble: 9 × 2
#>   Kategori            Antall
#>   <chr>                <int>
#> 1 Arbeidsmarked            4
#> 2 Boligmarked              2
#> 3 Demografi                1
#> 4 Energi og råvarer        1
#> 5 Finansmarkeder           1
#> 6 Lønn og inntekt          1
#> 7 Nasjonalregnskap         2
#> 8 Priser og inflasjon      2
#> 9 Utenriksøkonomi          2
```
