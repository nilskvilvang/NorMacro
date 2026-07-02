
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
  oseax <- get_oseax()
  strompris <- get_strompris()
  offentlig_finans <- get_offentlig_finans()
  offentlige_utgifter <- get_offentlige_utgifter()
  kreditt <- get_kreditt()
  boliginvesteringer <- get_boliginvesteringer()
  husholdningsgjeld <- get_husholdningsgjeld()
  offentlige_investeringer <- get_offentlige_investeringer()
  konsum <- get_konsum()
  sparing <- get_sparing()
  disponibel_inntekt <- get_disponibel_inntekt()
  fastlandsinvesteringer <- get_fastlandsinvesteringer()
  industriproduksjon <- get_industriproduksjon()
  byggeaktivitet <- get_byggeaktivitet()
  detaljhandel <- get_detaljhandel()
  kapasitetsutnytting <- get_kapasitetsutnytting()
  
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
    dplyr::left_join(oseax, by = "Aar") |>
    dplyr::left_join(strompris, by = "Aar") |>
    dplyr::left_join(offentlig_finans, by = "Aar") |>
    dplyr::left_join(offentlige_utgifter, by = "Aar") |>
    dplyr::left_join(kreditt, by = "Aar") |>
    dplyr::left_join(boliginvesteringer, by = "Aar") |>
    dplyr::left_join(husholdningsgjeld, by = "Aar") |>
    dplyr::left_join(offentlige_investeringer, by = "Aar") |>
    dplyr::left_join(konsum, by = "Aar") |>
    dplyr::left_join(sparing, by = "Aar") |>
    dplyr::left_join(disponibel_inntekt, by = "Aar") |>
    dplyr::left_join(fastlandsinvesteringer, by = "Aar") |>
    dplyr::left_join(industriproduksjon, by = "Aar") |>
    dplyr::left_join(byggeaktivitet, by = "Aar") |>
    dplyr::left_join(detaljhandel, by = "Aar") |>
    dplyr::left_join(kapasitetsutnytting, by = "Aar") |>
    create_derived_variables() 
}
