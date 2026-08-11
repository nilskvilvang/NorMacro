
#' Normaliser sammenligningsserier
#'
#' Normaliserer seriene i et `comparison_series`-objekt til indeks 100 i et
#' felles basisår.
#'
#' Metoden er en snarvei til `index(x, base_year = ..., base_value = 100)`.
#'
#' @param x Et `comparison_series`-objekt.
#' @param base_year Valgfritt basisår. Hvis `NULL`, brukes første felles år
#'   med gyldige observasjoner for alle seriene.
#' @param ... Videre argumenter til metoden.
#'
#' @return Et indeksert `comparison_series`-objekt med basisverdi 100.
#'
#' @method normalize comparison_series
#' @export

normalize.comparison_series <- function(x, base_year = NULL, ...) {
  index(x, base_year = base_year, base_value = 100)
}
