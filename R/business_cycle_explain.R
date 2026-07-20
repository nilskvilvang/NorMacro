

business_cycle_explain <- function(year, data = NULL, ...) {
  cycle <- business_cycle(data = data, ...)
  
  result <- cycle |>
    dplyr::filter(Aar == year)
  
  if (nrow(result) == 0) {
    stop("Fant ikke året i konjunkturklassifiseringen: ", year)
  }
  
  cat("\n")
  cat("Konjunkturklassifisering\n")
  cat("========================\n\n")
  
  cat("År:    ", result$Aar[1], "\n", sep = "")
  cat("Fase:  ", result$Fase[1], "\n", sep = "")
  cat("Score: ", result$Score[1], "\n\n", sep = "")
  
  cat("Delkomponenter\n")
  cat("--------------\n")
  cat(sprintf("%-24s %+4.0f\n", "BNP-vekst", result$Score_BNP[1]))
  cat(sprintf("%-24s %+4.0f\n", "NAV-ledighet", result$Score_ledighet[1]))
  cat(sprintf(
    "%-24s %+4.0f\n",
    "Konjunkturindikator",
    result$Score_konjunktur[1]
  ))
  cat(sprintf(
    "%-24s %+4.0f\n",
    "Kapasitetsutnytting",
    result$Score_kapasitet[1]
  ))
  
  if ("Score_rentekurve" %in% names(result)) {
    cat(sprintf("%-24s %+4.0f\n", "Rentekurve", result$Score_rentekurve[1]))
  }
  
  cat("\n")
  cat("Underliggende verdier\n")
  cat("---------------------\n")
  cat(sprintf("%-24s %8.2f\n", "BNP-vekst", result$BNP_Fastland_vekst[1]))
  cat(sprintf(
    "%-24s %8.2f\n",
    "NAV-ledighet",
    result$Arbledighetsrate_NAV[1]
  ))
  cat(sprintf(
    "%-24s %8.2f\n",
    "Konjunkturindikator",
    result$Konjunkturindikator[1]
  ))
  cat(sprintf(
    "%-24s %8.2f\n",
    "Kapasitetsutnytting",
    result$Kapasitetsutnytting[1]
  ))
  
  if ("Rentekurve" %in% names(result)) {
    cat(sprintf("%-24s %8.2f\n", "Rentekurve", result$Rentekurve[1]))
  }
  
  cat("\n")
  
  invisible(result)
}