
get_bnp_fastland <- function(){
  
  query <- list(
    Makrost = "bnpb.nr23_9fn",
    ContentsCode = "Faste",
    Tid = "*"
  )
  
  bnp <- ssb_get(
    url = "https://data.ssb.no/api/v0/no/table/nk/nk03/knr/SBMENU5140/NRMakroHov",
    query = query
  )
  
  names(bnp) <- c("Makrost", "Aar", "BNP_Fastland")
  
  bnp |>
    dplyr::mutate(
      Aar = as.integer(Aar),
      BNP_Fastland = as.numeric(BNP_Fastland)
    ) |>
    dplyr::select(Aar, BNP_Fastland) |>
    dplyr::arrange(Aar) |>
    dplyr::mutate(
      BNP_Fastland_vekst =
        (BNP_Fastland / dplyr::lag(BNP_Fastland) - 1) * 100
    )
  
}
