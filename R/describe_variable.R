
#' Beskriv en variabel i NorMacro
#'
#' Viser metadata for én variabel, blant annet beskrivelse, kilde, enhet,
#' frekvens, dekningsperiode, tilhørende funksjon og eventuell tabell- og
#' kommentarinformasjon.
#'
#' Funksjonen er nyttig når du har funnet en variabel og ønsker å forstå
#' hva den måler og hvor dataene kommer fra før variabelen brukes i en
#' analyse.
#'
#' @param variable Navnet på variabelen som skal beskrives.
#' @param print Logisk verdi. Dersom `TRUE`, skrives en lesbar
#'   metadataoversikt til konsollen. Standard er `TRUE`.
#'
#' @return Metadata for den valgte variabelen, returnert usynlig.
#'
#' @examples
#' \dontrun{
#' describe_variable("BNP_Fastland")
#' }
#'
#' @export

describe_variable <- function(variable, print = TRUE) {
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(Variabel == variable)
  
  if (nrow(result) == 0) {
    stop("Fant ikke variabelen i metadata: ", variable, call. = FALSE)
  }
  
  if (print) {
    cat("\n")
    cat("Variabel:   ", result$Variabel, "\n")
    cat("Beskrivelse:", result$Beskrivelse, "\n")
    cat("Kilde:      ", result$Kilde, "\n")
    cat("Enhet:      ", result$Enhet, "\n")
    cat("Frekvens:   ", result$Frekvens, "\n")
    cat("Startår:    ", result$Startaar, "\n")
    cat("Sluttår:    ", ifelse(is.na(result$Sluttaar), "NA", result$Sluttaar), "\n")
    cat("Funksjon:   ", result$Funksjon, "\n")
    cat("Tabell:     ", result$Tabell, "\n")
    cat("Kommentar:  ", result$Kommentar, "\n")
    cat("\n")
  }
  
  invisible(result)
}
