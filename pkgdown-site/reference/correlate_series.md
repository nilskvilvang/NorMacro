# Beregn korrelasjoner mellom tidsserier

Beregner parvise korrelasjoner mellom valgte variabler over en angitt
periode.

## Usage

``` r
correlate_series(
  variables,
  data = NULL,
  start_year = NULL,
  end_year = NULL,
  method = c("pearson", "spearman", "kendall"),
  include_diagonal = FALSE,
  format = TRUE
)
```

## Arguments

- variables:

  En tegnvektor med variabler som skal analyseres.

- data:

  Datasett som inneholder \`Aar\` og de valgte variablene. Hvis
  \`NULL\`, brukes NorMacros standarddata.

- start_year:

  Valgfritt første år i analyseperioden.

- end_year:

  Valgfritt siste år i analyseperioden.

- method:

  Korrelasjonsmetode: \`"pearson"\`, \`"spearman"\` eller \`"kendall"\`.

- include_diagonal:

  Logisk. Om korrelasjonen mellom en variabel og seg selv skal
  inkluderes.

- format:

  Logisk. Om resultatet skal formateres for lesbar presentasjon.

## Value

En tibble med parvise korrelasjoner og tilhørende informasjon.

## Examples

``` r
correlate_series(
  c("Inflasjon", "Styringsrente", "BNP_Fastland_vekst"),
  data = normacro_example
)
#> # A tibble: 3 × 11
#>   Variabel_x    Display_x     Variabel_y         Display_y   Korrelasjon P_verdi
#>   <chr>         <chr>         <chr>              <chr>       <chr>       <chr>  
#> 1 Inflasjon     Inflasjon     BNP_Fastland_vekst BNP Fastla… -0,094      0,647  
#> 2 Styringsrente Styringsrente BNP_Fastland_vekst BNP Fastla… 0,054       0,793  
#> 3 Inflasjon     Inflasjon     Styringsrente      Styringsre… 0,036       0,861  
#> # ℹ 5 more variables: Antall_observasjoner <int>, Metode <chr>, Startaar <dbl>,
#> #   Sluttaar <dbl>, Signifikant <chr>
```
