
build_database <- function(){
  
  kpi <- get_kpi()
  befolkning <- get_befolkning()
  arbeidsstyrke <- get_arbeidsstyrke()
  ledighet <- get_ledighet()
  rente <- get_rente()
  bnp_lopende  <- get_bnp()
  bnp_fastland <- get_bnp_fastland()
  
  kpi |>
    dplyr::left_join(befolkning, by = "Aar") |>
    dplyr::left_join(arbeidsstyrke, by = "Aar") |>
    dplyr::left_join(ledighet, by = "Aar") |>
    dplyr::left_join(rente, by = "Aar") |>
    dplyr::left_join(bnp_lopende, by = "Aar") |>
    dplyr::left_join(bnp_fastland, by = "Aar")
}
