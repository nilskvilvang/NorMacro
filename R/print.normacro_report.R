
#' @export
print.normacro_report <- function(
    x,
    ...
) {
  cat("\n")
  cat("NorMacro makrorapport\n")
  cat("=====================\n\n")
  
  cat(
    "\u00c5r: ",
    x$year,
    "\n\n",
    sep = ""
  )
  
  if (nrow(x$business_cycle) > 0L) {
    cat("Konjunkturfase\n")
    cat("--------------\n")
    
    cat(
      "Fase:  ",
      x$business_cycle$Fase[[1]],
      "\n",
      sep = ""
    )
    
    cat(
      "Score: ",
      x$business_cycle$Score[[1]],
      "\n\n",
      sep = ""
    )
  }
  
  cat("N\u00f8kkeltall\n")
  cat("----------\n")
  
  print(
    x$key_indicators |>
      dplyr::select(
        Display_navn,
        Verdi,
        Enhet,
        Kategori,
        Kilde
      )
  )
  
  invisible(
    x
  )
}
