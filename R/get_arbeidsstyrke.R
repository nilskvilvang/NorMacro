

get_arbeidsstyrke <- function(refresh = FALSE) {
  cache_get(
    name = "arbeidsstyrke",
    refresh = refresh,
    fun = function() {
      query <- list(
        Alder = "15-74",
        Kjonn = c("2", "1"),
        ContentsCode = "Personer",
        Tid = "*"
      )
      
      arbeidsstyrke_raw <- ssb_get(url = "https://data.ssb.no/api/v0/no/table/al/al03/aku/SBMENU9728/ArbStyrkAar", query = query)
      
      arbeidsstyrke_raw |>
        dplyr::rename(Aar = ar, Arbeidsstyrke_1000 = personer_i_arbeidsstyrken_1_000_personer) |>
        dplyr::mutate(Aar = as.integer(Aar),
                      Arbeidsstyrke_1000 = as.numeric(Arbeidsstyrke_1000)) |>
        dplyr::group_by(Aar) |>
        dplyr::summarise(
          Arbeidsstyrke = sum(Arbeidsstyrke_1000, na.rm = TRUE) * 1000,
          .groups = "drop"
        ) |>
        dplyr::arrange(Aar)
    }
  )
}
