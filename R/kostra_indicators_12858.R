
kostra_indicators_12858 <- function() {
  
  tibble::tibble(
    KOKartkap0000 = c(
      "AGD13",
      "AGD9",
      "AGD18",
      "AGD21a",
      "AGD21",
      "AGD26",
      "AG6",
      "A990",
      "AGD23",
      "AGI1",
      "AGI2",
      "AGID1",
      "AGI36",
      "AGID2"
    ),
    Variabel = c(
      "Brutto_driftsinntekter",
      "Brutto_driftsutgifter",
      "Brutto_driftsresultat",
      "Avdrag_korrigert",
      "Avdrag_netto",
      "Finansutgifter_netto",
      "Utlaan",
      "Motpost_avskrivninger",
      "Netto_driftsresultat",
      "Brutto_investeringsutgifter",
      "Tilskudd_refusjoner_salgsinntekter",
      "Overskudd_foer_laan_og_avsetninger",
      "Bruk_av_laan_netto",
      "Bruk_av_fond_netto"
    ),
    Display_navn = c(
      "Brutto driftsinntekter i alt",
      "Brutto driftsutgifter totalt",
      "Brutto driftsresultat",
      "Avdrag i driftsregnskapet, korrigert",
      "Avdrag (netto) i driftsregnskapet",
      "Finans(utgift) (netto)",
      "Utlån",
      "Motpost avskrivninger",
      "Netto driftsresultat",
      "Brutto investeringsutgifter totalt",
      "Tilskudd, refusjoner, salgsinntekter",
      "Overskudd før lån og avsetninger",
      "Bruk av lån inkl. aksjer, andeler og utlån (netto)",
      "Bruk av fond/avsetning til fond, drift og investering"
    ),
    Enhet = "1000 kroner",
    Analyse_type = "level"
  )
}


