# Historiske makroøkonomiske episoder

Returnerer en kuratert katalog over utvalgte historiske makroøkonomiske
episoder i Norge. Episodene er valgt for å knytte sentrale økonomiske
hendelser til relevante variabler i NorMacro.

## Usage

``` r
historical_episodes(episode = NULL, theme = NULL)
```

## Arguments

- episode:

  Valgfri tegnvektor med episode-ID-er. Hvis \`NULL\`, returneres alle
  episoder.

- theme:

  Valgfri tekst for filtrering på tema.

## Value

En tibble med episode-ID, navn, periode, tema, kort beskrivelse og
relevante NorMacro-variabler.

## Examples

``` r
historical_episodes()
#> # A tibble: 5 × 7
#>   Episode_id          Episode Startaar Sluttaar Tema  Kort_beskrivelse Variabler
#>   <chr>               <chr>      <int>    <int> <chr> <chr>            <chr>    
#> 1 bankkrisen_1988     Bankkr…     1988     1993 Fina… Bankkrise, svak… BNP_Fast…
#> 2 finanskrisen_2008   Finans…     2008     2009 Inte… Global finanskr… BNP_Fast…
#> 3 oljeprisfallet_2014 Oljepr…     2014     2016 Olje… Kraftig fall i … Oljepris…
#> 4 pandemien_2020      Pandem…     2020     2021 Pand… Kraftig fall i … BNP_Fast…
#> 5 inflasjonssjokket_… Inflas…     2021     2023 Infl… Kraftig økning … Inflasjo…

historical_episodes(
  episode = "finanskrisen_2008"
)
#> # A tibble: 1 × 7
#>   Episode_id        Episode   Startaar Sluttaar Tema  Kort_beskrivelse Variabler
#>   <chr>             <chr>        <int>    <int> <chr> <chr>            <chr>    
#> 1 finanskrisen_2008 Finanskr…     2008     2009 Inte… Global finanskr… BNP_Fast…

historical_episodes(
  theme = "inflasjon"
)
#> # A tibble: 1 × 7
#>   Episode_id          Episode Startaar Sluttaar Tema  Kort_beskrivelse Variabler
#>   <chr>               <chr>      <int>    <int> <chr> <chr>            <chr>    
#> 1 inflasjonssjokket_… Inflas…     2021     2023 Infl… Kraftig økning … Inflasjo…
```
