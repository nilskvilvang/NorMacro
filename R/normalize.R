
#' Normaliser sammenligningsserier
#'
#' Generisk funksjon for normalisering av serier. For `comparison_series`
#' tilsvarer normalisering indeksering til 100 i et felles basisår.
#'
#' @param x Objektet som skal normaliseres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et normalisert objekt. For `comparison_series` returneres et
#'   indeksert `comparison_series`-objekt med basisverdi 100.
#'
#' @seealso [combine_series()], [index()], [growth()]
#'
#' @export

normalize <- function(x, ...) {
  UseMethod("normalize")
}
