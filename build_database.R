
build_database <- function(){
  
  kpi <- get_kpi()
  befolkning <- get_befolkning()
  arbeidsstyrke <- get_arbeidsstyrke()
  ledighet <- get_ledighet()
  
  kpi |>
    dplyr::left_join(befolkning, by = "Aar") |>
    dplyr::left_join(arbeidsstyrke, by = "Aar") |>
    dplyr::left_join(ledighet, by = "Aar")
}