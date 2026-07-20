
get_ressursknapphet <- function(refresh = FALSE) {
  cache_get(
    name = "ressursknapphet",
    refresh = refresh,
    fun = function() {
      ressurs_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk02/kbar/KBarAvledIndik",
        query = list(
          PKoder = "P105",
          Justering = "S",
          ContentsCode = "RessursKnapphet",
          Tid = "*"
        )
      )
      
      ressurs_raw |>
        dplyr::transmute(
          Aar = as.integer(substr(kvartal, 1, 4)),
          Ressursknapphet = as.numeric(indikator_pa_ressursknapphet)
        ) |>
        dplyr::filter(!is.na(Ressursknapphet)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(Ressursknapphet = mean(Ressursknapphet, na.rm = TRUE),
                         .groups = "drop") |>
        dplyr::arrange(Aar)
    }
  )
}