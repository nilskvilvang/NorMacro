
get_kapasitetsutnytting <- function(refresh = FALSE) {
  cache_get(
    name = "kapasitetsutnytting",
    refresh = refresh,
    fun = function() {
      kapasitet_raw <- ssb_get(
        url = "https://data.ssb.no/api/v0/no/table/nk/nk02/kbar/KBarAvledIndik",
        query = list(
          PKoder = "P105",
          Justering = "S",
          ContentsCode = "Kapasitetsutnyt",
          Tid = "*"
        )
      )
      
      kapasitet_raw |>
        dplyr::transmute(
          Aar = as.integer(substr(kvartal, 1, 4)),
          Kapasitetsutnytting = as.numeric(kapasitetsutnyttingsgraden_veid_gjennomsnitt)
        ) |>
        dplyr::filter(!is.na(Kapasitetsutnytting)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Kapasitetsutnytting = mean(Kapasitetsutnytting, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}