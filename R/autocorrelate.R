
#' Beregn autokorrelasjon i sammenligningsserier
#'
#' Generisk funksjon for autokorrelasjonsanalyse. For et
#' `comparison_series` beregnes autokorrelasjon separat for hver serie
#' og de valgte lagene.
#'
#' @param x Objektet som skal analyseres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et autokorrelasjonsresultat. For `comparison_series` returneres
#'   et objekt av klassen `comparison_series_autocorrelation`.
#'
#' @seealso [combine_series()], [correlate()], [regress()]
#'
#' @export

autocorrelate <- function(x, ...) {
  UseMethod("autocorrelate")
}
