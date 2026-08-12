# Lag veksttabell

Beregner samlet vekst og gjennomsnittlig årlig vekst (CAGR) for valgte
variabler over én eller flere perioder.

## Usage

``` r
growth_table(variables, data = NULL, periods = c(1, 5, 10))
```

## Arguments

- variables:

  En tegnvektor med variabler som skal analyseres.

- data:

  Datasett som inneholder \`Aar\` og de valgte variablene. Hvis
  \`NULL\`, brukes NorMacros standarddata.

- periods:

  Numerisk vektor med antall år det skal beregnes vekst over. Standard
  er 1, 5 og 10 år.

## Value

En tibble med siste observasjon, samlet vekst og CAGR for hver angitt
periode.

## Details

Beregningene tar utgangspunkt i den siste tilgjengelige observasjonen
for hver variabel.

## Examples

``` r
growth_table(
  c("Befolkning", "Arbeidsstyrke", "Sysselsatte"),
  data = normacro_example
)
#> # A tibble: 3 × 9
#>   Display_navn  Siste_aar Siste_verdi Vekst_1aar CAGR_1aar Vekst_5aar CAGR_5aar
#>   <chr>             <dbl>       <dbl>      <dbl>     <dbl>      <dbl>     <dbl>
#> 1 Befolkning         2025     5594340      0.795     0.795       4.22     0.831
#> 2 Arbeidsstyrke      2025     3039000      0.997     0.997       6.97     1.36 
#> 3 Sysselsatte        2025     2903000      0.485     0.485       7.12     1.39 
#> # ℹ 2 more variables: Vekst_10aar <dbl>, CAGR_10aar <dbl>
```
