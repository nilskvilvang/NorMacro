
get_offentlig_finans <- function(){
  
  offentlig_raw <- ssb_get(
    url = "https://data.ssb.no/api/v0/no/table/os/os04/offogjeld/SBMENU5263/FinansUnder",
    query = list(
      Sektor = "100",
      FinansObjekt = c("44", "46"),
      ContentsCode = "Behold",
      Tid = "*"
    )
  )
  
  offentlig_raw |>
    dplyr::mutate(
      Aar = as.integer(ar),
      beholdninger = as.numeric(beholdninger)
    ) |>
    dplyr::select(Aar, finansobjekt, beholdninger) |>
    tidyr::pivot_wider(
      names_from = finansobjekt,
      values_from = beholdninger
    ) |>
    dplyr::rename(
      Offentlig_gjeld = `GJELD I ALT`,
      Offentlig_nettofordringer = Nettofordringer
    ) |>
    dplyr::arrange(Aar)
}