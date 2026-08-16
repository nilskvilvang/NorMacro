# Hent metadata for internasjonale NorMacro-data

Returnerer metadata for variablene i NorMacros internasjonale
makrodatasett.

## Usage

``` r
get_international_metadata()
```

## Value

En tibble med internasjonale variabelmetadata.

## Examples

``` r
get_international_metadata()
#> # A tibble: 45 × 16
#>    Variabel Display_navn Type  Kategori Beskrivelse Kilde Kilde_url Tabell Enhet
#>    <chr>    <chr>        <chr> <chr>    <chr>       <chr> <chr>     <chr>  <chr>
#>  1 HICP     Harmonisert… Orig… Priser … Harmoniser… Euro… https://… prc_h… Inde…
#>  2 Befolkn… Befolkning   Orig… Demogra… Befolkning… Euro… https://… demo_… Pers…
#>  3 Arbeids… Arbeidsledi… Orig… Arbeids… Arbeidsled… Euro… https://… une_r… Pros…
#>  4 BNP_lop… BNP løpende  Orig… Nasjona… Bruttonasj… Euro… https://… nama_… Mill…
#>  5 BNP_fas… BNP faste p… Orig… Nasjona… Bruttonasj… Euro… https://… nama_… Mill…
#>  6 Industr… Industripro… Orig… Produks… Produksjon… Euro… https://… sts_i… Inde…
#>  7 Syssels… Sysselsatte  Orig… Arbeids… Sysselsatt… Euro… https://… nama_… Pers…
#>  8 Arbeids… Arbeidsstyr… Orig… Arbeids… Personer i… Euro… https://… lfsi_… Pers…
#>  9 Offentl… Offentlig g… Bere… Offentl… Offentlig … Euro… https://… gov_1… Pros…
#> 10 Boligpr… Boligprisin… Orig… Boligma… Prisindeks… Euro… https://… prc_h… Inde…
#> # ℹ 35 more rows
#> # ℹ 7 more variables: Frekvens <chr>, Startaar <dbl>, Sluttaar <dbl>,
#> #   Funksjon <chr>, Kommentar <chr>, Omraade <chr>, Analyse_type <chr>
```
