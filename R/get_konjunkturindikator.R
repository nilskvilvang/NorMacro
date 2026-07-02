
get_konjunkturindikator <- function(refresh = FALSE){
  
  cache_get(
    name = "konjunkturindikator",
    refresh = refresh,
    fun = function(){
      
      konj_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk02/kbar/KBarAvledIndik",
        query = list(
          PKoder = "P105",
          Justering = "S",
          ContentsCode = "SammensattKonj",
          Tid = "*"
        )
      )
      
      konj_raw |>
        dplyr::transmute(
          Aar = as.integer(substr(kvartal, 1, 4)),
          Konjunkturindikator = as.numeric(sammensatt_konjunkturindikator)
        ) |>
        dplyr::filter(!is.na(Konjunkturindikator)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Konjunkturindikator = mean(Konjunkturindikator, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}