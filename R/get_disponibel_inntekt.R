
get_disponibel_inntekt <- function(){
  
  disp_inntekt_raw <- ssb_get(
    url = "https://data.ssb.no/api/v0/no/table/nk/nk03/knri/NRI",
    query = list(
      Sektor = "140000",
      Transaksjoner = "i3491_",
      ContentsCode = "LPriser",
      Tid = "*"
    )
  )
  
  disp_inntekt_raw |>
    dplyr::transmute(
      Aar = as.integer(ar),
      Disponibel_inntekt_husholdninger =
        as.numeric(lopende_priser)
    ) |>
    dplyr::arrange(Aar)
}