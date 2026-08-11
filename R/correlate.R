
#' Beregn korrelasjoner mellom sammenligningsserier
#'
#' Generisk funksjon for korrelasjonsanalyse. For et `comparison_series`
#' beregnes parvise korrelasjoner mellom seriene.
#'
#' @param x Objektet som skal analyseres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et korrelasjonsresultat. For `comparison_series` returneres et
#'   objekt av klassen `comparison_series_correlation`.
#'
#' @seealso [combine_series()], [regress()], [autocorrelate()]
#'
#' @export

correlate <- function(x, ...) {
  UseMethod("correlate")
}