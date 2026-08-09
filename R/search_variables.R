
#' Søk etter variabler
#'
#' Søker i NorMacros metadata etter variabler som matcher et tekstuttrykk.
#' Søket omfatter variabelnavn, visningsnavn, beskrivelse, kommentar og
#' kategori.
#'
#' Funksjonen gjør det mulig å finne relevante data uten å kjenne de
#' eksakte NorMacro-variabelnavnene på forhånd.
#'
#' @param query Tekst eller regulært uttrykk det skal søkes etter.
#' @param ignore_case Logisk verdi som angir om store og små bokstaver
#'   skal behandles likt. Standard er `TRUE`.
#'
#' @return En tibble med variabler som matcher søket og relevant metadata,
#'   blant annet visningsnavn, kategori, beskrivelse, enhet, frekvens,
#'   dekningsperiode, kilde og område.
#'
#' @examples
#' \dontrun{
#' search_variables("arbeidsledighet")
#' search_variables("BNP")
#' }
#'
#' @export

search_variables <- function(query, ignore_case = TRUE) {
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(
      grepl(query, .data$Variabel, ignore.case = ignore_case) |
        grepl(query, .data$Display_navn, ignore.case = ignore_case) |
        grepl(query, .data$Beskrivelse, ignore.case = ignore_case) |
        grepl(query, .data$Kommentar, ignore.case = ignore_case) |
        grepl(query, .data$Kategori, ignore.case = ignore_case)
    ) |>
    dplyr::select(
      Variabel,
      Display_navn,
      Kategori,
      Beskrivelse,
      Enhet,
      Frekvens,
      Startaar,
      Sluttaar,
      Kilde,
      Omraade
    ) |>
    dplyr::arrange(.data$Display_navn, .data$Variabel)
  
  if (nrow(result) == 0) {
    message("Fant ingen variabler som matcher s\u00f8ket: ", query)
  }
  
  result
}
