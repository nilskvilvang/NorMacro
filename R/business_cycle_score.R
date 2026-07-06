
business_cycle_score <- function(
    data = NULL,
    bnp_weight = 2,
    unemployment_weight = 2,
    confidence_weight = 2,
    capacity_weight = 1,
    yield_curve_weight = 1,
    include_yield_curve = TRUE
){
  
  if(is.null(data)){
    data <- suppressMessages(get_normacro())
  }
  
  required <- c(
    "Aar",
    "BNP_Fastland_vekst",
    "Arbledighetsrate_NAV",
    "Konjunkturindikator",
    "Kapasitetsutnytting"
  )
  
  if(include_yield_curve){
    required <- c(required, "Rentekurve")
  }
  
  missing <- setdiff(required, names(data))
  
  if(length(missing) > 0){
    stop(
      "Fant ikke nødvendige variabler i datasettet: ",
      paste(missing, collapse = ", ")
    )
  }
  
  result <- data |>
    dplyr::select(dplyr::all_of(required)) |>
    dplyr::mutate(
      
      Score_BNP = dplyr::case_when(
        BNP_Fastland_vekst < 0 ~ -2,
        BNP_Fastland_vekst >= 0 & BNP_Fastland_vekst < 1 ~ -1,
        BNP_Fastland_vekst >= 1 & BNP_Fastland_vekst <= 3 ~ 1,
        BNP_Fastland_vekst > 3 ~ 2,
        TRUE ~ NA_real_
      ) * bnp_weight,
      
      Score_ledighet = dplyr::case_when(
        Arbledighetsrate_NAV > 5 ~ -2,
        Arbledighetsrate_NAV > 3 & Arbledighetsrate_NAV <= 5 ~ -1,
        Arbledighetsrate_NAV >= 2 & Arbledighetsrate_NAV <= 3 ~ 1,
        Arbledighetsrate_NAV < 2 ~ 2,
        TRUE ~ NA_real_
      ) * unemployment_weight,
      
      Score_konjunktur = dplyr::case_when(
        Konjunkturindikator < -5 ~ -2,
        Konjunkturindikator >= -5 & Konjunkturindikator < 0 ~ -1,
        Konjunkturindikator >= 0 & Konjunkturindikator <= 5 ~ 1,
        Konjunkturindikator > 5 ~ 2,
        TRUE ~ NA_real_
      ) * confidence_weight,
      
      Score_kapasitet = dplyr::case_when(
        Kapasitetsutnytting < 75 ~ -1,
        Kapasitetsutnytting >= 75 & Kapasitetsutnytting <= 80 ~ 0,
        Kapasitetsutnytting > 80 ~ 1,
        TRUE ~ NA_real_
      ) * capacity_weight
    )
  
  if(include_yield_curve){
    result <- result |>
      dplyr::mutate(
        Score_rentekurve = dplyr::case_when(
          Rentekurve < 0 ~ -1,
          Rentekurve >= 0 ~ 1,
          TRUE ~ NA_real_
        ) * yield_curve_weight
      )
  } else {
    result <- result |>
      dplyr::mutate(
        Score_rentekurve = NA_real_
      )
  }
  
  score_cols <- c(
    "Score_BNP",
    "Score_ledighet",
    "Score_konjunktur",
    "Score_kapasitet"
  )
  
  if(include_yield_curve){
    score_cols <- c(score_cols, "Score_rentekurve")
  }
  
  result |>
    dplyr::mutate(
      Score = rowSums(
        dplyr::pick(dplyr::all_of(score_cols)),
        na.rm = TRUE
      ),
      Antall_indikatorer = rowSums(
        !is.na(dplyr::pick(dplyr::all_of(score_cols)))
      )
    ) |>
    dplyr::filter(Antall_indikatorer > 0)
}
