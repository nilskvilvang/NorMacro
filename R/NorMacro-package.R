
#' NorMacro: Norwegian Macroeconomic Data and Analysis Tools
#'
#' NorMacro gir reproduserbar tilgang til kuraterte økonomiske data og
#' analyseverktøy for norsk og internasjonal økonomi.
#'
#' Pakken kombinerer tre datalag:
#'
#' - norske makroøkonomiske tidsserier
#' - internasjonale indikatorer for sammenligning mellom land
#' - utvalgte kommunale og regionale nøkkeltall fra KOSTRA
#'
#' Dataene suppleres med standardiserte metadata og verktøy for utforsking,
#' visualisering, sammenligning og statistisk analyse.
#'
#' ## Data og utforsking
#'
#' Norske makrodata hentes med `get_normacro()`, mens internasjonale data
#' hentes med `get_international_macro()`. Utvalgte KOSTRA-data kan hentes
#' med `get_kostra_keyfigures()`.
#'
#' Funksjoner som `overview()`, `coverage()`, `search_variables()` og
#' `describe_variable()` kan brukes til å utforske datasett og metadata.
#'
#' ## Direkte analyse
#'
#' For raske analyser tilbyr NorMacro oppgaveorienterte funksjoner som
#' `plot_series()`, `compare_series()`, `scatter_series()`,
#' `correlate_series()` og `growth_table()`.
#'
#' Disse funksjonene opererer direkte på variabelnavn og datasett og krever
#' ingen egen objektmodell.
#'
#' ## Objektbasert analyse
#'
#' Mer sammensatte analyser kan bygges med `combine_series()`, som oppretter
#' et `comparison_series`-objekt.
#'
#' Slike objekter kan transformeres og analyseres videre med blant annet
#' `index()`, `normalize()`, `growth()`, `correlate()`, `regress()` og
#' `autocorrelate()`.
#'
#' Dette API-et er laget for kjedbare og reproduserbare arbeidsflyter der
#' valg av serier, transformasjon og analyse holdes eksplisitt adskilt.
#'
#' ## KOSTRA
#'
#' KOSTRA-delen av NorMacro inneholder egne funksjoner for oversikt,
#' rangering, sammenligning og benchmarking av kommunale og regionale
#' nøkkeltall.
#'
#' Sentrale innganger er `overview_kostra_data()`, `rank_kostra()`,
#' `benchmark_kostra()` og `kostra_timeseries_benchmark()`.
#'
#' @keywords internal
#' @importFrom stats residuals fitted nobs coef formula vcov
#' @importFrom utils tail download.file
#' @importFrom graphics plot lines points abline legend
"_PACKAGE"
