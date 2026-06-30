describe_variable <- function(variable){
  
  metadata <- get_metadata()
  
  result <- metadata |>
    dplyr::filter(Variabel == variable)
  
  if(nrow(result) == 0){
    stop("Fant ikke variabelen i metadata: ", variable)
  }
  
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
  
  invisible(result)
}