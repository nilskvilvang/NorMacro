
#' Beregn vekst eller endring i sammenligningsserier
#'
#' Generisk funksjon for å beregne vekst eller absolutt endring i et
#' objekt. For `comparison_series` utføres transformasjonen separat for
#' hver serie.
#'
#' @param x Objektet som skal transformeres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et transformert objekt. For `comparison_series` returneres et
#'   nytt `comparison_series`-objekt.
#'
#' @seealso [combine_series()], [index()], [normalize()]
#'
#' @export

growth <- function(x, ...) {
  UseMethod("growth")
}
