# Vis siste tilgjengelige observasjoner

Finner den siste tilgjengelige observasjonen for hver variabel i et
NorMacro-datasett og kombinerer resultatet med sentrale metadata.

## Usage

``` r
latest_observations(data = NULL, category = NULL, source = NULL)
```

## Arguments

- data:

  Datasettet som skal undersøkes. Hvis \`NULL\`, brukes NorMacros
  standarddata.

- category:

  Valgfri kategori som resultatet skal begrenses til.

- source:

  Valgfri datakilde som resultatet skal begrenses til.

## Value

En tibble med siste år, siste verdi og metadata for hver variabel.

## Examples

``` r
latest_observations(
  data = normacro_example
)
#> # A tibble: 16 × 10
#>    Siste_aar Variabel  Siste_verdi Display_navn Kategori Type  Beskrivelse Enhet
#>        <dbl> <chr>           <dbl> <chr>        <chr>    <chr> <chr>       <chr>
#>  1      2025 Arbeidss…  3039000    Arbeidsstyr… Arbeids… Orig… Personer i… Pers…
#>  2      2025 Arbledig…    63036    Arbledige N… Arbeids… Orig… Registrert… Pers…
#>  3      2025 Arbledig…        2.1  Arbledighet… Arbeids… Orig… Registrert… Pros…
#>  4      2025 Sysselsa…  2903000    Sysselsatte  Arbeids… Orig… Sysselsatt… Pers…
#>  5      2025 Boligpri…      152.   Boligprisin… Boligma… Orig… Prisindeks… Inde…
#>  6      2025 Boligpri…        5.46 Boligprisve… Boligma… Bere… Årlig pros… Pros…
#>  7      2025 Befolkni…  5594340    Befolkning   Demogra… Orig… Befolkning… Pers…
#>  8      2025 Oljepris…       69.1  Oljepris USD Energi … Orig… Brent Blen… USD …
#>  9      2025 Styrings…        4.30 Styringsren… Finansm… Orig… Norges Ban… Pros…
#> 10      2025 Lonnvekst        4.9  Lonnvekst    Lønn og… Orig… Årslønn, p… Pros…
#> 11      2025 BNP_Fast…  4117384    BNP Fastland Nasjona… Orig… BNP Fastla… Mill…
#> 12      2025 BNP_Fast…        1.72 BNP Fastlan… Nasjona… Bere… Årsvekst i… Pros…
#> 13      2025 Inflasjon        2.99 Inflasjon    Priser … Bere… Årsvekst i… Pros…
#> 14      2025 KPI            100    KPI          Priser … Orig… Konsumpris… 2025…
#> 15      2025 Eksport    2673535    Eksport      Utenrik… Orig… Eksport i … Mill…
#> 16      2025 Import     1770968    Import       Utenrik… Orig… Import i a… Mill…
#> # ℹ 2 more variables: Kilde <chr>, Analyse_type <chr>
```
