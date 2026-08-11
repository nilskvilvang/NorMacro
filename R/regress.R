
#' Estimer regresjonsmodeller for sammenligningsserier
#'
#' Generisk funksjon for regresjonsanalyse. For et `comparison_series`
#' angis modellen med en vanlig R-formel der variablene er `Serie_id`-ene
#' i objektet.
#'
#' @param x Objektet som skal analyseres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et regresjonsresultat. For `comparison_series` returneres et
#'   objekt av klassen `comparison_series_regression`.
#'
#' @seealso [combine_series()], [correlate()], [autocorrelate()]
#'
#' @export

regress <- function(x, ...) {
  UseMethod("regress")
}