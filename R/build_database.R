
build_database <- function(){
  
  kpi <- get_kpi()
  befolkning <- get_befolkning()
  arbeidsstyrke <- get_arbeidsstyrke()
  sysselsatte <- get_sysselsatte()
  ledighet <- get_ledighet()
  rente <- get_rente()
  bnp_lopende <- get_bnp_lopende()
  bnp_fastland <- get_bnp_fastland()
  lonn <- get_lonn()
  boligpriser <- get_boligpriser()
  oljepris <- get_oljepris()
  valutakurs <- get_valutakurs()
  utenrikshandel <- get_utenrikshandel()
  
  kpi |>
    dplyr::left_join(befolkning, by = "Aar") |>
    dplyr::left_join(arbeidsstyrke, by = "Aar") |>
    dplyr::left_join(sysselsatte, by = "Aar") |>
    dplyr::left_join(ledighet, by = "Aar") |>
    dplyr::left_join(rente, by = "Aar") |>
    dplyr::left_join(bnp_lopende, by = "Aar") |>
    dplyr::left_join(bnp_fastland, by = "Aar") |>
    dplyr::left_join(lonn, by = "Aar") |>
    dplyr::left_join(valutakurs, by = "Aar") |>
    dplyr::left_join(boligpriser, by = "Aar") |>
    dplyr::left_join(oljepris, by = "Aar") |>
    dplyr::left_join(utenrikshandel, by = "Aar") |>
    create_derived_variables() 
}
