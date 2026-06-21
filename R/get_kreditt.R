
get_kreditt <- function(){
  
  kreditt_raw <- ssb_get(
    url = "https://data.ssb.no/api/v0/no/table/bf/bf02/kredind/InnLandGjeldNY",
    query = list(
      Valuta = "00",
      Lantaker2 = "Kred01",
      Kredittkilde = "LTOT",
      ContentsCode = "Bruttogjeld",
      Tid = "*"
    )
  )
  
  kreditt_raw |>
    dplyr::transmute(
      Aar = as.integer(substr(maned, 1, 4)),
      Kreditt_K2 = as.numeric(innenlandsk_lanegjeld)
    ) |>
    dplyr::group_by(Aar) |>
    dplyr::summarise(
      Kreditt_K2 = mean(Kreditt_K2, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(Aar) |>
    dplyr::mutate(
      Kredittvekst_K2 =
        (Kreditt_K2 / dplyr::lag(Kreditt_K2) - 1) * 100
    )
}
