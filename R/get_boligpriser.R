
get_boligpriser <- function(){
  
  bolig_raw <- suppressWarnings(
    ssb_get(
      url = "https://data.ssb.no/api/v0/no/table/pp/pp01/bpi/SBMENU7481/NyBoligindeks3",
      query = list(
        Region = "TOTAL",
        Boligtype = "00",
        ContentsCode = "BruktBlindex",
        Tid = "*"
      )
    )
  )
  
  bolig_raw |>
    dplyr::rename(
      Aar = ar,
      Boligprisindeks = prisindeks_for_brukte_boliger
    ) |>
    dplyr::mutate(
      Aar = as.integer(Aar),
      Boligprisindeks = as.numeric(Boligprisindeks)
    ) |>
    dplyr::select(Aar, Boligprisindeks) |>
    dplyr::arrange(Aar) |>
    dplyr::mutate(
      Boligprisvekst =
        (Boligprisindeks / dplyr::lag(Boligprisindeks) - 1) * 100
    )
}