get_offentlige_utgifter <- function(refresh = FALSE) {
  cache_get(
    name = "offentlige_utgifter",
    refresh = refresh,
    fun = function() {
      off_utg_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/os/os02/offinnut/SBMENU4642/OffInnUt21",
        query = list(
          Art = "E",
          Sektor = c("C_OFF", "6100", "6500"),
          ContentsCode = "Belop",
          Tid = "*"
        )
      )
      
      off_utg_raw |>
        dplyr::mutate(Aar = as.integer(ar), belop = as.numeric(belop)) |>
        dplyr::select(Aar, sektor, belop) |>
        tidyr::pivot_wider(names_from = sektor, values_from = belop) |>
        dplyr::rename(
          Offentlige_utgifter = `Offentlig forvaltning`,
          Statlige_utgifter = Statsforvaltningen,
          Kommunale_utgifter = Kommuneforvaltningen
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
