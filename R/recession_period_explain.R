
recession_period_explain <- function(
    start_year,
    end_year = start_year,
    data = NULL,
    ...
){
  
  cycle <- business_cycle(
    data = data,
    ...
  ) |>
    dplyr::filter(
      Aar >= start_year,
      Aar <= end_year
    )
  
  if(nrow(cycle) == 0){
    stop("Fant ingen konjunkturklassifisering for valgt periode.")
  }
  
  cat("\n")
  cat("Forklaring av konjunkturperiode\n")
  cat("===============================\n\n")
  
  cat("Periode: ", start_year, "-", end_year, "\n\n", sep = "")
  
  print(
    cycle |>
      dplyr::select(
        Aar,
        Fase,
        Score,
        Score_BNP,
        Score_ledighet,
        Score_konjunktur,
        Score_kapasitet,
        Score_rentekurve
      )
  )
  
  cat("\n")
  cat("Underliggende verdier\n")
  cat("---------------------\n")
  
  print(
    cycle |>
      dplyr::select(
        Aar,
        BNP_Fastland_vekst,
        Arbledighetsrate_NAV,
        Konjunkturindikator,
        Kapasitetsutnytting,
        Rentekurve
      )
  )
  
  invisible(cycle)
}