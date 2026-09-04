
build_database <- function() {
  kpi <- get_kpi()
  kpi_jae <- get_kpi_jae()
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
  driftsbalanse <- get_driftsbalanse()
  netto_iip <- get_netto_iip()
  aksjekursindeks <- get_aksjekursindeks()
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
  investeringer <- get_investeringer()
  industriproduksjon <- get_industriproduksjon()
  byggeaktivitet <- get_byggeaktivitet()
  igangsatte_boliger <- get_igangsatte_boliger()
  detaljhandel <- get_detaljhandel()
  kapasitetsutnytting <- get_kapasitetsutnytting()
  konjunkturindikator <- get_konjunkturindikator()
  inflation_expectations <- get_inflation_expectations()
  ressursknapphet <- get_ressursknapphet()
  ordrebeholdning <- get_ordrebeholdning()
  pengemarkedsrente <- get_pengemarkedsrente()
  statsrente <- get_statsrente()
  tjenesteproduksjon <- get_tjenesteproduksjon()
  
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
    dplyr::left_join(driftsbalanse, by = "Aar") |>
    dplyr::left_join(netto_iip, by = "Aar") |>
    dplyr::left_join(aksjekursindeks, by = "Aar") |>
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
    dplyr::left_join(investeringer, by = "Aar") |>
    dplyr::left_join(industriproduksjon, by = "Aar") |>
    dplyr::left_join(byggeaktivitet, by = "Aar") |>
    dplyr::left_join(igangsatte_boliger, by = "Aar") |>
    dplyr::left_join(detaljhandel, by = "Aar") |>
    dplyr::left_join(kapasitetsutnytting, by = "Aar") |>
    dplyr::left_join(konjunkturindikator, by = "Aar") |>
    dplyr::left_join(inflation_expectations, by = "Aar") |>
    dplyr::left_join(ressursknapphet, by = "Aar") |>
    dplyr::left_join(ordrebeholdning, by = "Aar") |>
    dplyr::left_join(pengemarkedsrente, by = "Aar") |>
    dplyr::left_join(statsrente, by = "Aar") |>
    dplyr::left_join(tjenesteproduksjon, by = "Aar") |>
    dplyr::full_join(kpi_jae, by = "Aar") |>
  
  create_derived_variables()
}
