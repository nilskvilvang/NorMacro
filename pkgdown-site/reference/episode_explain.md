# Forklar en historisk makroepisode

Viser en kort beskrivelse av en kuratert historisk episode og relevante
NorMacro-variabler for perioden.

## Usage

``` r
episode_explain(episode, data = NULL)
```

## Arguments

- episode:

  Episode-ID fra \[historical_episodes()\].

- data:

  Norsk NorMacro-datasett. Hvis \`NULL\`, brukes \[get_normacro()\].

## Value

Usynlig en liste med episodeinformasjon og datauttrekk.

## Examples

``` r
episode_explain("finanskrisen_2008", data = normacro_example)
#> 
#> Finanskrisen 2008-2009 
#> ======================
#> 
#> Periode: 2008-2009
#> Tema:    Internasjonal finanskrise
#> 
#> Global finanskrise med kraftig svekkelse i aktivitet, eksport og finansmarkeder. 
#> 
#> Relevante variabler
#> -------------------
#> BNP_Fastland_vekst, Eksport, Styringsrente 
#> 
#> Mangler i datasettet: Valutakurs_I44
#> 
#> Data
#> ----
#>    Aar BNP_Fastland_vekst Eksport Styringsrente
#> 1 2008           2.245227 2112030        5.8075
#> 2 2009          -1.339765 2022912        2.2575
```
