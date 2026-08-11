
#' Indekser en sammenligningsserie
#'
#' Omdanner serier til en felles indeks med valgt basisår og basisverdi.
#'
#' @param x Objektet som skal indekseres.
#' @param ... Tilleggsargumenter sendt til metode.
#'
#' @return Et indeksert objekt.
#'
#' @export
index <- function(
    x,
    ...
) {
  UseMethod(
    "index"
  )
}