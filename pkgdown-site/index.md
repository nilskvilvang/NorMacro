# NorMacro

NorMacro er en R-pakke for utforsking, visualisering og analyse av norsk
og internasjonal økonomi.

Pakken kombinerer tre datalag i ett konsistent API:

- kuraterte norske makroøkonomiske tidsserier
- internasjonale indikatorer for sammenligning mellom land
- kommunale og regionale nøkkeltall fra KOSTRA

Dataene suppleres med standardiserte metadata og funksjoner for
utforsking, sammenligning, visualisering og analyse.

## Hva inneholder NorMacro?

### Norske makrodata

NorMacro samler et kuratert utvalg norske makroøkonomiske indikatorer
fra blant annet priser, arbeidsmarked, nasjonalregnskap, boligmarked,
finansmarkeder, utenriksøkonomi og offentlige finanser.

Det fullstendige datasettet hentes med:

``` r

normacro <- get_normacro()
```

### Internasjonale data

NorMacro inneholder også standardiserte makroøkonomiske indikatorer for
Norge og utvalgte europeiske land.

``` r

international <- get_international_macro()
```

De internasjonale dataene bruker samme variabelstruktur på tvers av land
og er laget for sammenlignende analyser.

### KOSTRA

NorMacro gir standardisert tilgang til et kuratert utvalg
KOSTRA-tabeller for kommunale og regionale analyser.

KOSTRA-verktøyene støtter blant annet oversikt, metadata, rangering og
sammenligning mellom enheter.

## Installasjon

NorMacro kan installeres direkte fra GitHub:

``` r

remotes::install_github(
  "nilskvilvang/NorMacro"
)
```

Last deretter pakken:

``` r

library(NorMacro)
```

## Kom i gang

En naturlig start er å få oversikt over de norske makrodataene:

``` r

overview()
```

Finn tilgjengelige variabler:

``` r

list_variables()
```

Søk etter et økonomisk tema:

``` r

search_variables("inflasjon")
```

Undersøk en variabel nærmere:

``` r

describe_variable("Inflasjon")
```

Hent deretter datasettet dersom du vil arbeide eksplisitt med det:

``` r

normacro <- get_normacro()
```

## Analyse av norske data

README-eksemplene bruker et lite statisk datasett som følger med pakken,
slik at de kan kjøres uten eksterne API-kall.

``` r

data(normacro_example)

variable_summary(
  "Inflasjon",
  data = normacro_example
)
```

``` R
Variabel
--------
Inflasjon 
(Inflasjon)

Beskrivelse
-----------
Årsvekst i KPI 

Metadata
--------
Kategori: Priser og inflasjon
Type:     Beregnet
Kilde:    Beregnet
Enhet:    Prosent
Frekvens: Årlig
Analysetype: rate

Dekning
-------
2000-2025
Observasjoner: 26

Siste observasjon
-----------------
År:    2025
Verdi: 2.986612

Oppsummering
------------
# A tibble: 1 × 8
  Display_navn Siste_aar Siste_verdi Gjennomsnitt Median Minimum Maksimum
  <chr>            <dbl>       <dbl>        <dbl>  <dbl>   <dbl>    <dbl>
1 Inflasjon         2025        2.99         2.47   2.27   0.512     5.81
# ℹ 1 more variable: Standardavvik <dbl>

Sterkeste korrelasjoner
-----------------------
# A tibble: 5 × 3
  Display_navn         Variabel             Korrelasjon
  <chr>                <chr>                      <dbl>
1 Eksport              Eksport                    0.545
2 KPI                  KPI                        0.518
3 Arbledighetsrate NAV Arbledighetsrate_NAV      -0.485
4 Arbeidsstyrke        Arbeidsstyrke              0.477
5 Boligprisindeks      Boligprisindeks            0.476
```

### Visualiser en tidsserie

``` r

plot_series(
  "Inflasjon",
  data = normacro_example
)
```

![](README_files/figure-commonmark/fig-inflation-1.png)

Figure 1: Inflasjon i Norge, 2000–2025.

### Sammenlign flere serier

``` r

compare_series(
  c(
    "Inflasjon",
    "BNP_Fastland_vekst",
    "Arbledighetsrate_NAV",
    "Styringsrente"
  ),
  data = normacro_example
)
```

![](README_files/figure-commonmark/fig-compare-series-1.png)

Figure 2: Sammenligning av utvalgte norske makroserier.

### Undersøk korrelasjoner

``` r

correlate_series(
  c(
    "Inflasjon",
    "BNP_Fastland_vekst",
    "Arbledighetsrate_NAV",
    "Styringsrente"
  ),
  data = normacro_example
)
```

``` R
# A tibble: 6 × 11
  Variabel_x           Display_x        Variabel_y Display_y Korrelasjon P_verdi
  <chr>                <chr>            <chr>      <chr>     <chr>       <chr>  
1 Inflasjon            Inflasjon        Arbledigh… Arbledig… -0,485      0,012  
2 BNP_Fastland_vekst   BNP Fastland ve… Arbledigh… Arbledig… -0,275      0,173  
3 Arbledighetsrate_NAV Arbledighetsrat… Styringsr… Styrings… -0,176      0,389  
4 Inflasjon            Inflasjon        BNP_Fastl… BNP Fast… -0,094      0,647  
5 BNP_Fastland_vekst   BNP Fastland ve… Styringsr… Styrings… 0,054       0,793  
6 Inflasjon            Inflasjon        Styringsr… Styrings… 0,036       0,861  
# ℹ 5 more variables: Antall_observasjoner <int>, Metode <chr>, Startaar <dbl>,
#   Sluttaar <dbl>, Signifikant <chr>
```

## Internasjonale sammenligninger

Det statiske eksempeldatasettet `normacro_international_example`
inneholder data for Norge, Sverige, Danmark, Finland, Tyskland og
Frankrike.

``` r

data(normacro_international_example)
data(normacro_international_example_metadata)
```

Sammenlign inflasjonen mellom Norge, Sverige og Danmark:

``` r

plot_series(
  "Inflasjon",
  data = normacro_international_example,
  metadata = normacro_international_example_metadata,
  countries = c("NO", "SE", "DK")
)
```

![](README_files/figure-commonmark/fig-international-inflation-1.png)

Figure 3: Inflasjon i Norge, Sverige og Danmark.

Flere variabler kan også sammenlignes innen ett land:

``` r

compare_series(
  c(
    "Inflasjon",
    "BNP_vekst",
    "Arbeidsledighetsrate"
  ),
  data = normacro_international_example,
  country = "NO"
)
```

![](README_files/figure-commonmark/fig-norway-international-data-1.png)

Figure 4: Inflasjon, BNP-vekst og arbeidsledighet i Norge.

## KOSTRA

NorMacro inneholder også et statisk KOSTRA-eksempeldatasett med Oslo,
Bergen og Trondheim.

``` r

data(normacro_kostra_example)

overview_kostra_data(
  normacro_kostra_example
)
```

``` R
KOSTRA-data
===========

Tabell: 12134
Tema:   Utvalgte nøkkeltall for kommuneregnskap

Kommunale og regionale nøkkeltall fra KOSTRA.

Dekning
-------
Periode:        2020-2025
Observasjoner:  18
Enheter:        3
Variabler:      3

Enhetstyper
-----------
kommune                          3
```

Kommunene kan for eksempel rangeres etter netto driftsresultat:

``` r

rank_kostra(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  year = 2025
)
```

``` R
# A tibble: 3 × 6
   Rang Enhet Enhet_navn Enhetstype   Aar Verdi
  <int> <chr> <chr>      <chr>      <int> <dbl>
1     1 5001  Trondheim  kommune     2025   6  
2     2 0301  Oslo       kommune     2025   3.7
3     3 4601  Bergen     kommune     2025   1  
```

Rangeringen kan visualiseres direkte:

``` r

plot_kostra_ranking(
  "Netto_driftsresultat",
  data = normacro_kostra_example,
  year = 2025
)
```

![](README_files/figure-commonmark/fig-kostra-ranking-1.png)

Figure 5: Netto driftsresultat i Oslo, Bergen og Trondheim i 2025.

## Sentrale funksjoner

Noen av de viktigste funksjonene i NorMacro er:

- [`overview()`](https://nilskvilvang.github.io/NorMacro/reference/overview.md)
  – oversikt over makrodatasettet
- [`list_variables()`](https://nilskvilvang.github.io/NorMacro/reference/list_variables.md)
  og
  [`search_variables()`](https://nilskvilvang.github.io/NorMacro/reference/search_variables.md)
  – finn variabler
- [`describe_variable()`](https://nilskvilvang.github.io/NorMacro/reference/describe_variable.md)
  og
  [`variable_summary()`](https://nilskvilvang.github.io/NorMacro/reference/variable_summary.md)
  – forstå og oppsummer serier
- [`coverage()`](https://nilskvilvang.github.io/NorMacro/reference/coverage.md)
  – undersøk datadekning
- [`plot_series()`](https://nilskvilvang.github.io/NorMacro/reference/plot_series.md)
  – visualiser tidsserier
- [`compare_series()`](https://nilskvilvang.github.io/NorMacro/reference/compare_series.md)
  – sammenlign flere serier
- [`correlate_series()`](https://nilskvilvang.github.io/NorMacro/reference/correlate_series.md)
  – beregn parvise korrelasjoner
- [`growth_table()`](https://nilskvilvang.github.io/NorMacro/reference/growth_table.md)
  – analyser vekst over flere perioder
- [`latest_observations()`](https://nilskvilvang.github.io/NorMacro/reference/latest_observations.md)
  – finn siste tilgjengelige observasjoner
- [`overview_kostra_data()`](https://nilskvilvang.github.io/NorMacro/reference/overview_kostra_data.md)
  – oversikt over KOSTRA-data
- [`rank_kostra()`](https://nilskvilvang.github.io/NorMacro/reference/rank_kostra.md)
  og
  [`compare_kostra_units()`](https://nilskvilvang.github.io/NorMacro/reference/compare_kostra_units.md)
  – sammenlign KOSTRA-enheter

Se funksjonenes hjelpesider i R for full dokumentasjon.

## Dokumentasjon

NorMacro inneholder fire introduksjonsvignetter:

1.  **Kom i gang med NorMacro** – finn data, variabler og metadata
2.  **Introduksjon til NorMacro** – grunnleggende analyse og
    visualisering
3.  **Internasjonale sammenligninger med NorMacro** – analyser på tvers
    av land
4.  **KOSTRA-analyse med NorMacro** – kommunale og regionale
    sammenligninger

Vignettene kan åpnes med:

``` r

browseVignettes("NorMacro")
```

## Datakilder

NorMacro henter data fra offentlige og etablerte datakilder, blant
annet:

- Statistisk sentralbyrå (SSB)
- Norges Bank
- NAV
- Eurostat
- Federal Reserve Economic Data (FRED)

Detaljert kildeinformasjon følger de enkelte variablene i metadataene.

## Prinsipper

NorMacro bygger på noen enkle prinsipper:

- representative indikatorer fremfor flest mulig serier
- én anbefalt serie per økonomisk fenomen
- offentlige originalkilder når det er mulig
- metadata som en integrert del av databasen
- transparente beregninger
- konsistente datastrukturer
- reproduserbar datainnhenting og analyse

## Lisens

Datakildene tilhører de respektive institusjonene.

NorMacro distribuerer kode for innhenting, standardisering,
dokumentasjon og analyse av offentlig tilgjengelige data.
