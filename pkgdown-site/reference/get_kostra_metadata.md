# Hent metadata for et KOSTRA-datasett

Henter metadata for indikatorene i en støttet KOSTRA-tabell. Tabellen
kan identifiseres enten fra attributtene på et KOSTRA-datasett eller ved
å oppgi tabellnummer eksplisitt.

## Usage

``` r
get_kostra_metadata(data = NULL, table = NULL)
```

## Arguments

- data:

  Valgfritt KOSTRA-datasett med attributtet \`kostra_table\`.

- table:

  Valgfritt KOSTRA-tabellnummer.

## Value

En tibble med metadata for indikatorene i KOSTRA-tabellen.

## Examples

``` r
get_kostra_metadata(
  data = normacro_kostra_example
)
#> # A tibble: 9 × 5
#>   ContentsCode Variabel                          Display_navn Enhet Analyse_type
#>   <chr>        <chr>                             <chr>        <chr> <chr>       
#> 1 KOSAGD230000 Netto_driftsresultat              Netto drift… pros… rate        
#> 2 KOSAGD290000 Merforbruk_driftsregnskap         Årets merfo… pros… rate        
#> 3 KOSKG280000  Arbeidskapital_uten_premieavvik   Arbeidskapi… pros… rate        
#> 4 KOSKG400000  Netto_renteeksponering            Netto rente… pros… rate        
#> 5 KOSKG320000  Langsiktig_gjeld_uten_pensjonsfo… Langsiktig … pros… rate        
#> 6 KOSAG110000  Frie_inntekter_per_innbygger      Frie inntek… kr    nivå        
#> 7 KOSKG210000  Fri_egenkapital_drift             Fri egenkap… pros… rate        
#> 8 KOSAGI10000  Brutto_investeringsutgifter       Brutto inve… pros… rate        
#> 9 KOSAGI210000 Egenfinansiering_investeringer    Egenfinansi… pros… rate        
```
